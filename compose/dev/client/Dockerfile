FROM node:carbon

WORKDIR /usr/src/app

COPY ./roadmap/lib/assets/package*.json ./

RUN npm install

VOLUME /usr/src/app
# Required for Webpack
CMD ["npm", "run", "bundle"]