FROM node:latest

WORKDIR /dishify

ADD . .

RUN npm install

CMD [ "node", "app.js" ]


