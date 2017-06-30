
FROM redis:3.2
MAINTAINER Jason Waldrip <jwaldrip@commercialtribe.com>
USER root
ADD https://storage.googleapis.com/kubernetes-release/release/v1.6.0/bin/linux/amd64/kubectl /usr/local/bin/kubectl
RUN ls -l /usr/local/bin/
RUN chmod +x /usr/local/bin/kubectl
RUN chgrp -R 42 /usr/local/bin/kubectl \
    && chown -R 42 /usr/local/bin/kubectl \
    && chmod -R g+rwX /usr/local/bin/kubectl

WORKDIR /app
ADD . /app
RUN chmod +x /app/sidecar.sh
CMD /app/sidecar.sh
