FROM centos:centos7
MAINTAINER Jason Waldrip <jwaldrip@commercialtribe.com>

ADD https://storage.googleapis.com/kubernetes-release/release/v1.6.0/bin/linux/amd64/kubectl /usr/local/bin/kubectl

RUN whoami
RUN groups
RUN ls -la /usr/local/bin/kubectl
RUN chgrp -R redis /usr/local/bin/kubectl \
  && chown -R redis /usr/local/bin/kubectl \
  && chmod -R g+rwX /usr/local/bin/kubectl

WORKDIR /app
ADD . /app
run ls -la /app

RUN chgrp -R redis /app \
  && chown -R redis /app \
  && chmod -R g+rwX /app

RUN ls -la /app/sidecar.sh

USER redis

CMD /app/sidecar.sh
