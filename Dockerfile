FROM redis:3.2
MAINTAINER Jason Waldrip <jwaldrip@commercialtribe.com>

USER redis

ADD https://storage.googleapis.com/kubernetes-release/release/v1.6.0/bin/linux/amd64/kubectl /usr/local/bin/kubectl

RUN whoami
RUN groups
RUN ls -la /usr/local/bin/kubectl
#RUN chmod -R g+rwX /usr/local/bin/kubectl

WORKDIR /app
ADD . /app
run ls -la /app
RUN chmod +x /app/sidecar.sh
RUN ls -la /app/sidecar.sh


CMD /app/sidecar.sh
