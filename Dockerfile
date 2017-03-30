# Copyright 2017 oleks <oleks@oleks.info>
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not
# use this file except in compliance with the License. A copy of the License
# text is included alongside this file as LICENSE.md.
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
# License for the specific language governing permissions and limitations under
# the License.

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
