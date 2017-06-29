FROM centos/redis
MAINTAINER Merkel

ADD https://storage.googleapis.com/kubernetes-release/release/v1.6.0/bin/linux/amd64/kubectl /usr/local/bin/kubectl

RUN ls -la /usr/local/bin/kubectl
RUN chgrp -R 997 /usr/local/bin/kubectl \
  && chown -R 997 /usr/local/bin/kubectl \
  && chmod -R g+rwX /usr/local/bin/kubectl
  
WORKDIR /app
ADD . /app
run ls -la /app

RUN chgrp -R 997 /app \
  && chown -R 997 /app \
  && chmod -R g+rwX /app

RUN ls -la /app/sidecar.sh

USER 997

CMD /app/sidecar.sh
