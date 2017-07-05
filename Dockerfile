
FROM redis:3.2
MAINTAINER Jason Waldrip <jwaldrip@commercialtribe.com>
USER root
ADD https://storage.googleapis.com/kubernetes-release/release/v1.6.0/bin/linux/amd64/kubectl /usr/local/bin/kubectl

RUN ls -l /usr/local/bin/
RUN chgrp -R redis /usr/local/bin/kubectl
RUN chown -R redis /usr/local/bin/kubectl
RUN chmod -R g+rwX /usr/local/bin/kubectl

WORKDIR /app
ADD . /app

RUN chgrp -R redis /app
RUN chown -R redis /app
RUN chmod -R g+rwX /app/sidecar.sh

USER redis

CMD /app/sidecar.sh
