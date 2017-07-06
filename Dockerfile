
FROM redis:3.2
MAINTAINER Jason Waldrip <jwaldrip@commercialtribe.com>
USER root
ADD https://storage.googleapis.com/kubernetes-release/release/v1.6.0/bin/linux/amd64/kubectl /usr/local/bin/kubectl

RUN ls -l /usr/local/bin/
RUN chgrp -R 42 /usr/local/bin/kubectl
RUN chown -R 42 /usr/local/bin/kubectl
RUN chmod -R g+rwX /usr/local/bin/kubectl

WORKDIR /app
ADD . /app

RUN chgrp -R 42 /app
RUN chown -R 42 /app
RUN chmod -R g+rwX /app/sidecar.sh

RUN chgrp -R 42 /data
RUN chown -R 42 /data

USER 42

CMD /app/sidecar.sh
