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
    apt-get install -y \
        gettext-base \
        git \
        curl \
        vim \
        iputils-ping \
        telnet \
        iproute2 \
        make

RUN curl -sL https://deb.nodesource.com/setup_10.x -o nodesource_setup.sh && \
    chmod +x nodesource_setup.sh && \
    ./nodesource_setup.sh \
    apt-get update && \
    apt-get install -y \
        nodejs && \
    node -v && \
    npm -v && \
    npm i -g pm2 && \
    npm i -g webpack webpack-cli webpack-merge

COPY files .

RUN git clone https://github.com/FDA/Healthy-Citizen-Code.git && \
    mv /Healthy-Citizen-Code/hc-data-bridge / && \
    cd /hc-data-bridge && \
    npm i
RUN mv /Healthy-Citizen-Code/adp-backend-v5 / && \
    cd /adp-backend-v5 && \
    npm i
RUN mv /Healthy-Citizen-Code/hc-widget / && \
    cd /hc-widget && \
    npm i
RUN mv /Healthy-Citizen-Code/hc-ui-util / && \
    cd /hc-ui-util && \
    npm i && \
    npm run build
RUN mv /Healthy-Citizen-Code/ha-dev / && \
    cd /ha-dev && \
    npm i
RUN cp /www/* /adp-backend-v5/model/public && \
    mkdir -p /var/log/hc && \
    chmod +x /start.sh && \
    echo "If you delete this file then the next time the container starts it will copy its default public contents into this folder" > /adp-backend-v5/model/public/public-read-me

VOLUME ["/var/log/hc", "/adp-backend-v5/model/public"]

EXPOSE 8000

CMD /start.sh