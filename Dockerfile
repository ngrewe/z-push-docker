FROM debian:11-slim
LABEL org.opencontainers.image.source=https://github.com/ngrewe/z-push-pg
ARG STAGE="final"
RUN apt-get update \
	&& apt-get -qqy --no-install-recommends install apt-transport-https curl ca-certificates gpg tini

RUN curl -sLo- https://download.kopano.io/zhub/z-push:/${STAGE}/Debian_11/Release.key | gpg --dearmor > /usr/share/keyrings/z-push.gpg \
	&& echo "deb [signed-by=/usr/share/keyrings/z-push.gpg]  https://download.kopano.io/zhub/z-push:/${STAGE}/Debian_11/ /" > /etc/apt/sources.list.d/z-push.list \
	&& apt-get update && apt-get -qqy --no-install-recommends install \
	z-push-backend-imap \
	z-push-autodiscover \
	z-push-state-sql \
	z-push-ipc-memcached \
	z-push-ipc-sharedmemory \
	php-fpm \
	php-pgsql \ 
	&& rm /etc/php/7.4/fpm/pool.d/www.conf
RUN addgroup --system --gid 999 z-push \
	&& adduser --system --home /var/lib/z-push --disabled-login --ingroup z-push --uid 999 z-push \
	&& mkdir -p /run/z-push \
	&& chown -R z-push:z-push /var/lib/z-push \
	&& chown -R z-push:z-push /run/z-push \
	&& chown -R z-push:z-push /var/log/z-push \
	&& sed -i s:/var/log:/var/log/z-push:g /etc/php/7.4/fpm/php-fpm.conf \
	&& sed -i s:/run/php:/run/z-push:g /etc/php/7.4/fpm/php-fpm.conf
COPY config/ /etc/z-push
COPY php-fpm/z-push.conf /etc/php/7.4/fpm/pool.d/z-push.conf
USER z-push
EXPOSE 9000
VOLUME ["/var/lib/z-push", "/var/log/z-push"]
ENTRYPOINT ["/usr/bin/tini", "/usr/sbin/php-fpm7.4", "--", "-F"]