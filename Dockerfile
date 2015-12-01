## -*- docker-image-name: "armbuild/scw-image-builder:latest" -*-
FROM scaleway/docker:1.9.0
MAINTAINER Scaleway <opensource@scaleway.com> (@scaleway)


# Prepare rootfs for image-builder
RUN /usr/local/sbin/builder-enter

# Install packages
RUN apt-get -qq update     \
 && apt-get -y -qq upgrade \
 && apt-get install -y -qq \
      s3cmd                \
      git                  \
      lftp                 \
      curl                 \
      nginx-full           \
 && apt-get clean

# Download scw
ENV SCW_VERSION 1.5.0
RUN curl -L https://github.com/scaleway/scaleway-cli/releases/download/v${SCW_VERSION}/scw_${SCW_VERSION}_armhf.deb  > scw.deb \
 && dpkg -i scw.deb \
 && rm scw.deb

# Patch rootfs
ADD ./patches/etc/ /etc/
ADD ./patches/usr/ /usr/

# Clean rootfs from image-builder
RUN /usr/local/sbin/builder-leave
