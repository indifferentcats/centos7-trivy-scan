#!/bin/bash

function log_it() { 
	tag="$1" 
	shift 1 
	printf "%s\t%s\t%s\n" "$(date +'%Y-%m-%dT%H:%M:%S.000%z')" "$tag" "$*"
}
log_warn() { log_it "WARN" "$*"; }
log_error() { log_it "ERROR" "$*"; }
log_info() { log_it "INFO" "$*"; }

all_cmds_available=1
for c in docker trivy jq; do
	if [ -z $(command -v $c) ]; then
		log_error "$c is not available"
		all_cmds_available=0
	fi
done
if [ $all_cmds_available -eq 0 ]; then
	log_error "One or more required executables are not available.  Stopping."
	exit 1
else
	log_info "All external commands are available for scanning"
fi

image_ids="$(docker image ls --filter 'dangling=false' -q)"
log_info "Found $(wc -w <<<$image_ids) local images"
for img in $image_ids; do
	repo_tag=$(docker image inspect $img | jq -r '.[].RepoTags[0]')
	results="scan_results-$img-$(date +%Y%m%d).json"
	summary="scan_summary-hc-$img-$(date +%Y%m%d).json"
	log_info "Scanning $img ($repo_tag)"

	trivy --security-checks vuln --format json image $img  > $results
	cat $results | jq '[.Results[].Vulnerabilities[] | {"Severity":.Severity,"PkgID":.PkgID,"PublishedDate":.PublishedDate} | select(.Severity=="CRITICAL" or .Severity=="HIGH")]' > $summary
done
log_info "Scanning completed"
