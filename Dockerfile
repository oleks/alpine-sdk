FROM alpine:3.5

ARG username=oleks
ARG name=oleks
ARG email=oleks@oleks.info

MAINTAINER ${name} <${email}>

RUN apk --no-cache add alpine-sdk

RUN adduser -D -u 1000 ${username}
USER ${username}

WORKDIR /home/${username}/

RUN git config --global user.name "${name}"
RUN git config --global user.email "${email}"
RUN git clone git://git.alpinelinux.org/aports

USER root

RUN \
  sed -i "s/^#PACKAGER=/PACKAGER=/" /etc/abuild.conf && \
  sed -i "s/^#MAINTAINER=/MAINTAINER=/" /etc/abuild.conf && \
  sed -i "s/Your Name <your@email\.address>/${name} <${email}>/" \
    /etc/abuild.conf

RUN mkdir -p /var/cache/distfiles
RUN chmod a+w /var/cache/distfiles

USER ${username}
RUN abuild-keygen -a -i

CMD ["ash"]
