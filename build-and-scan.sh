#!/bin/sh

all_cmds_available=1
for c in docker trivy jq; do
	if [ -z $(command -v $c) ]; then
		echo "ERROR: $c is not available"
		all_cmds_available=0
	fi
done
if [ $all_cmd_available -eq 0 ]; then
	echo "FATAL: One or more required executables are not available.  Stopping."
	exit 1
fi

docker build -t centos:7-$(date +%Y%m%d) .
results="scan_results-$(date +%Y%m%d-%H%M%S).json"
summary="scan_summary-hc-$(date +%Y%m%d-%H%M%S).json"
trivy --security-checks vuln --format json image centos:7-20221130  > $results
cat $results | jq '[.Results[].Vulnerabilities[] | {"Severity":.Severity,"PkgID":.PkgID,"PublishedDate":.PublishedDate} | select(.Severity=="CRITICAL" or .Severity=="HIGH")]' > $summary
echo "INFO: Detailed results are in $results"
echo "INFO: Critical/High results are in $summary"
