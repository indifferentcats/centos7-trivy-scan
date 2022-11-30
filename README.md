# CentOS7 Container Trivy Scan

This was a simple test to see how many findings would be found on
a fully patched `centos:7` container.  Trivy must be installed
and in the local path.  The `jq` program is also used to parse
outputs.

As of November 30, 2022, a fully patched container had no critical
findings and only two high findings (glib2 and krb5-libs).
