FROM node:14-alpine

WORKDIR /app

COPY  ./package* .

RUN   npm install

COPY . .

RUN adduser -D devops

RUN chown -R devops:devops /app

RUN chmod -R 750 /app

USER devops

EXPOSE 3000

ARG PORT
ARG MONGO_URI
ARG GOOGLE_CLIENT_ID
ARG GOOGLE_CLIENT_SECRET

RUN echo "PORT = ${PORT}" > /app/config/config.env &&\
    echo "MONGO_URI = ${MONGO_URI}" >> /app/config/config.env  &&\
    echo "GOOGLE_CLIENT_ID = ${GOOGLE_CLIENT_ID}" >> /app/config/config.env &&\
    echo "GOOGLE_CLIENT_SECRET = ${GOOGLE_CLIENT_SECRET}" >> /app/config/config.env

CMD [ "npm", "start" ] # for  production

# CMD [ "npm", "run", "dev" ] # for development