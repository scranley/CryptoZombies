FROM python:2.7.15-alpine
WORKDIR /home/cryptodapp
COPY . /home/cryptodapp
EXPOSE 9545 3000
RUN apk add --update sudo
RUN apk add --update nodejs nodejs-npm
