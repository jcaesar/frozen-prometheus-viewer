FROM ubuntu:eoan as dl
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get -y install \
		aria2 \
		ca-certificates

COPY opt/manifest /opt/manifest

RUN aria2c --allow-overwrite true --always-resume false --show-console-readout=false -j4 -d/opt --input-file=/opt/manifest
RUN mkdir /opt/prometheus && tar xvf /opt/prometheus.tgz --strip=1 --directory=/opt/prometheus
RUN rm -rf /opt/*.tgz

FROM ubuntu:eoan
ENV DEBIAN_FRONTEND noninteractive

COPY --from=dl /opt /opt
RUN apt-get update && apt-get -y install \
		jq \
		libfontconfig1 \
		moreutils \
		supervisor \
		tzdata \
	&& dpkg -i /opt/grafana.deb \
	&& apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives /var/log/apt /var/log/dpkg.log

RUN true \
	&& addgroup --system prometheus --quiet \
	&& adduser --system --home /opt/prometheus --no-create-home \
		--ingroup prometheus --disabled-password --shell /bin/false \
		prometheus \
	&& mkdir -p /var/lib/prometheus \
	&& chown -R prometheus /var/lib/prometheus \
	&& chmod 755 /var/lib/prometheus

ENTRYPOINT ["/usr/local/bin/entrypoint"]
EXPOSE 3000 9090
COPY . /
