# CentOS7 Container Trivy Scan

This was a simple test to see how many findings would be found on
a fully patched `centos:7` container.  Trivy must be installed
and in the local path.  The `jq` program is also used to parse
outputs.

As of November 30, 2022, a fully patched container had no critical
findings and only two high findings (glib2 and krb5-libs).

# Scan local folder

The `scan-local-images.sh` will perform a trivy scan against all
images on the local machine and spit out result files to the local folder.
Consider this a poor-man's approach to scanning.  Results are by
image ID to avoid duplicate scanning tags that point to the same image.
