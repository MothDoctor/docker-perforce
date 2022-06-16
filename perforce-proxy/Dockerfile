FROM ambakshi/perforce-base
MAINTAINER Amit Bakshi <ambakshi@gmail.com>

RUN yum install -y helix-proxy-2022.1 && \
    yum clean all --enablerepo='*' && \
    rm -rf /var/cache/yum/*

ENV P4TARGET perforce:1666
ENV P4PORT 1666
ENV P4PCACHE /cache

VOLUME ["$P4PCACHE"]

EXPOSE 1666

CMD ["/usr/bin/p4p"]
