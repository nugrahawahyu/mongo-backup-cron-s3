FROM alpine:3.6

LABEL maintainer="Wahyu Nugraha <nugraha.c.wahyu@gmail.com>"

ENV MONGO_HOST localhost
ENV MONGO_PORT 27017
ENV MONGO_DATABASE database
ENV MONGO_USERNAME ''
ENV MONGO_PASSWORD ''
ENV AWS_ACCESS_KEY_ID ''
ENV AWS_SECRET_ACCESS_KEY ''
ENV AWS_MONGO_BACKUP_PATH ''
ENV CRON 0 1 * * *

RUN apk -v --update add \
        python \
        py-pip \
        groff \
        less \
        mailcap \
        mongodb-tools \
        && \
    pip install --upgrade awscli==1.14.5 s3cmd==2.0.1 python-magic && \
    apk -v --purge del py-pip && \
    rm /var/cache/apk/*

RUN ["mkdir", "/app"]
RUN ["mkdir", "/app/tmp"]

WORKDIR /app

COPY ./mongo-s3-backup.sh /bin/mongo-s3-backup

RUN ["chmod", "+x", "/bin/mongo-s3-backup"]
RUN ["touch", "/var/log/cron.log"]
RUN ["truncate", "-s", "0", "/etc/crontabs/root"]

# Run the command on container startup
CMD echo "${CRON} mongo-s3-backup /app/tmp >> /var/log/cron.log 2>&1" >> /etc/crontabs/root && cat /etc/crontabs/root && crond && tail -f /var/log/cron.log
