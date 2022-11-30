FROM centos:7
RUN \
    rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 && \
    yum update -y -q -d2 && \
    yum clean all && \
    echo "This system was last updated on $(date)" > /root/last_patched.txt
