FROM ubuntu:24.04

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		cron \
		duplicity \
		lftp \
		python3-paramiko \
		openssh-client \
	&& rm -rf /var/lib/apt/lists/*
	
COPY backup.sh /opt/
COPY start.sh /opt/
COPY restore.sh /opt/

RUN chmod u+x /opt/*.sh

CMD ["/opt/start.sh"]
