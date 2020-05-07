FROM ubuntu:bionic

LABEL maintainer="andrey.mikhalchuk@conceptant.com"
LABEL version="0.5.5.1"
LABEL description="This Dockerfile builds Healthy Citizen Widgets docker image for a single base URL"
LABEL "com.conceptant.vendor"="Conceptant, Inc."

ENV APP_SERVER_URL=https://hc.preprod.fda.gov \
    DB_SERVER=db \
    EPIC_CLIENT_ID="specify-for-each-installation" \
    APP_ID="specify-for-each-installation" \
    DEFAULT_HC_ALGORITHM="openfda"

RUN apt-get update && \
    apt-get install -y apt-utils gnupg2 ca-certificates && \
    update-ca-certificates && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 4B7C549A058F8B6B && \
    echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.2 multiverse" | tee /etc/apt/sources.list.d/mongodb.list && \
    apt-get update && \
    apt-get install -y \
        gettext-base \
        git \
        curl \
        wget \
        vim \
        iputils-ping \
        telnet \
        iproute2 \
        make \
        g++ \
        openjdk-8-jdk \
        mongodb-org-shell \
        mongodb-org-tools

RUN curl -sL https://deb.nodesource.com/setup_10.x -o nodesource_setup.sh && \
    chmod +x nodesource_setup.sh && \
    ./nodesource_setup.sh \
    apt-get update && \
    apt-get install -y \
        nodejs && \
    node -v && \
    npm -v && \
    npm i -g pm2 && \
    npm i -g webpack webpack-cli webpack-merge && \
    mkdir /hc && \
    cd /hc

COPY files .

RUN git clone https://github.com/FDA/Healthy-Citizen-Code.git && \
    mv /Healthy-Citizen-Code/hc-data-bridge /hc && \
    cd /hc/hc-data-bridge && \
    npm i
RUN mv /Healthy-Citizen-Code/adp-backend-v5 /hc && \
    cd /hc/adp-backend-v5 && \
    npm i
RUN mv /Healthy-Citizen-Code/hc-widget /hc && \
    cd /hc/hc-widget && \
    npm i
RUN mv /Healthy-Citizen-Code/hc-ui-util /hc && \
    cd /hc/hc-ui-util && \
    npm i && \
    npm run build
RUN mv /Healthy-Citizen-Code/ha-dev /hc && \
    cd /hc/ha-dev && \
    npm i
RUN mv /Healthy-Citizen-Code/widget-manager /hc && \
    cd /hc/widget-manager && \
    npm i
RUN cp /www/* /hc/adp-backend-v5/model/public && \
    mkdir -p /var/log/hc && \
    chmod +x /start.sh && \
    echo "If you delete this file then the next time the container starts it will copy its default public contents into this folder" > /hc/adp-backend-v5/model/public/public-read-me

VOLUME ["/hc/adp-backend-v5/model/public"]

EXPOSE 8000

CMD /start.sh