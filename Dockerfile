#Testing version
FROM ubuntu:focal

#Known working version
#FROM ubuntu:bionic
MAINTAINER Nate Fugal <info@natefugal.tech>

ENV SQUEEZE_VOL /srv/squeezebox
ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive

#Testing verion
ENV PACKAGE_VERSION_URL=https://downloads.slimdevices.com/LogitechMediaServer_v8.2.0/logitechmediaserver_8.2.0_amd64.deb

#Known working version
#ENV PACKAGE_VERSION_URL=http://www.mysqueezebox.com/update/?version=7.9.0&revision=1&geturl=1&os=deb

RUN apt-get update && \
	apt-get -y install \
		curl \
		wget \
		faad \
		flac \
		lame \
		sox \
		libio-socket-ssl-perl \
		tzdata \
		&& \
	apt-get clean

RUN url=$(curl "$PACKAGE_VERSION_URL" | sed 's/_all\.deb/_amd64\.deb/') && \
	curl -Lsf -o /tmp/logitechmediaserver.deb $url && \
	dpkg -i /tmp/logitechmediaserver.deb && \
	rm -f /tmp/logitechmediaserver.deb && \
	apt-get clean

# This will be created by the entrypoint script.
RUN userdel squeezeboxserver

VOLUME $SQUEEZE_VOL
EXPOSE 3483 3483/udp 9000 9090

COPY entrypoint.sh /entrypoint.sh
COPY start-squeezebox.sh /start-squeezebox.sh
RUN chmod 755 /entrypoint.sh /start-squeezebox.sh
ENTRYPOINT ["/entrypoint.sh"]