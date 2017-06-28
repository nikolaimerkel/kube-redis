FROM redis:3.2
MAINTAINER Jason Waldrip <jwaldrip@commercialtribe.com>

ADD https://storage.googleapis.com/kubernetes-release/release/v1.6.0/bin/linux/amd64/kubectl /usr/local/bin/kubectl


RUN chgrp -R 0 /usr/local/bin/kubectl \
  && chmod +x /usr/local/bin/kubectl
  
RUN chmod +x /usr/local/bin/kubectl

WORKDIR /app
ADD . /app



RUN chmod +x /app/sidecar.sh
CMD /app/sidecar.sh
