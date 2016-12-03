
#####################
FROM nginx:1.11.6-alpine
MAINTAINER "Paolo D'Onorio De Meo <p.donoriodemeo@cineca.it>"

#####################
RUN apk update && apk add wget
WORKDIR /usr/share/nginx/html

ENV SWAGGER_MASTER https://github.com/swagger-api/swagger-ui/archive/master.zip
RUN wget --no-check-certificate -q $SWAGGER_MASTER \
    && unzip master.zip \
    && mv swagger-ui-master/dist swagger-ui \
    && rm -rf swagger-ui-master
