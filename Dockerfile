FROM armv8a/phusion_baseimage:focal-1.1.0

# USEAGE:
# sudo docker run --name webvirtcloud -d -p 80:80 -p 443:443 -p 6080:6080 armv8a/webvirtcloud
# login docker container,run:
# sudo docker exec -i -t webvirtcloud /bin/bash
# sudo -u www-data ssh-copy-id root@computer1
# or run:
# sudo-ssh-copy-id root@computer1
# exit

EXPOSE 80
EXPOSE 443
EXPOSE 6080

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

RUN rm -rf /etc/apt/sources.list
ADD sources.list  /etc/apt/sources.list

RUN apt clean all ; apt update ; apt upgrade -y

RUN echo 'APT::Get::Clean=always;' >> /etc/apt/apt.conf.d/99AutomaticClean

RUN apt-get update -qqy \
    && DEBIAN_FRONTEND=noninteractive apt-get -qyy install \
	--no-install-recommends \
	git \
	python3-venv \
	python3-dev \
	python3-lxml \
	libvirt-dev \
	zlib1g-dev \
	nginx \
	pkg-config \
	gcc g++ sudo \
	libldap2-dev \
	libssl-dev \
	libsasl2-dev \
	libsasl2-modules \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY . /srv/webvirtcloud
RUN chown -R www-data:www-data /srv/webvirtcloud

# Setup webvirtcloud
WORKDIR /srv/webvirtcloud
RUN python3 -m venv venv && \
	. venv/bin/activate && \
	pip3 install -i https://pypi.doubanio.com/simple -U pip && \
	pip3 install -i https://pypi.doubanio.com/simple wheel && \
	pip3 install -i https://pypi.doubanio.com/simple -r conf/requirements.txt && \
	chown -R www-data:www-data /srv/webvirtcloud

RUN . venv/bin/activate && \
    python3 manage.py migrate && \
	chown -R www-data:www-data /srv/webvirtcloud

# Setup Nginx
RUN printf "\n%s" "daemon off;" >> /etc/nginx/nginx.conf && \
	rm /etc/nginx/sites-enabled/default && \
	chown -R www-data:www-data /var/lib/nginx

COPY conf/nginx/webvirtcloud.conf /etc/nginx/conf.d/

# Register services to runit
RUN	mkdir /etc/service/nginx && \
	mkdir /etc/service/nginx-log-forwarder && \
	mkdir /etc/service/webvirtcloud && \
	mkdir /etc/service/novnc
COPY conf/runit/nginx				/etc/service/nginx/run
COPY conf/runit/nginx-log-forwarder	/etc/service/nginx-log-forwarder/run
COPY conf/runit/novncd.sh			/etc/service/novnc/run
COPY conf/runit/webvirtcloud.sh		/etc/service/webvirtcloud/run

# Define mountable directories.
#VOLUME []

RUN mkdir -p ~www-data/.ssh ; mkdir -p /var/www/.ssh ; chown www-data -R ~www-data
RUN echo  'Host *' >> ~www-data/.ssh/config ; echo 'StrictHostKeyChecking no' >> ~www-data/.ssh/config ; chown www-data -R ~www-data/.ssh/config
RUN sudo -u www-data ssh-keygen -t rsa -P "" -f ~www-data/.ssh/id_rsa
RUN rm -rf /root/.ssh ; ln -sf /var/www/.ssh /root/.ssh ; chgrp www-data /root ; chmod 770 /root
RUN echo 'sudo -u www-data ssh-copy-id $1' >  /usr/bin/sudo-ssh-copy-id ; chmod +x  /usr/bin/sudo-ssh-copy-id
RUN cp  /usr/bin/sudo-ssh-copy-id / ; cp  /usr/bin/sudo-ssh-copy-id /root/

# Add ssl crt
RUN mkdir /ssl && \
    openssl genrsa -out /ssl/srv.key 2048 && \
    openssl req -new -subj /C=CN/ST=CN/L=CN/O=WebVirtCloud/OU=PrivateCloud/CN=aarch64.pricate-webvirtcloud.org -key /ssl/srv.key -out /ssl/srv.csr && \
    openssl x509 -req -days 36500 -in /ssl/srv.csr -signkey /ssl/srv.key -out /ssl/srv.crt


WORKDIR /srv/webvirtcloud
