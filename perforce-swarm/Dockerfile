FROM ambakshi/perforce-base
LABEL Amit Bakshi <ambakshi@gmail.com>

RUN yum install -y centos-release-scl-rh centos-release-scl openssh-server && \
    yum install -y \
    helix-swarm-2022.1 \
    helix-cli-base-2022.1 \
    helix-swarm-triggers-2022.1 \
    rsyslog
## RUN yum install -y php-pecl-imagick

ENV P4PORT perforce:1666
ENV P4USER swarm
ENV P4PASSWD swarm
ENV MXHOST localhost

EXPOSE 80 443

ADD ./run.sh /

CMD ["/run.sh"]
