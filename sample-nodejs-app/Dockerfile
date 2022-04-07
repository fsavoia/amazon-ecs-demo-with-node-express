FROM node:alpine
RUN mkdir -p /usr/src/calc
WORKDIR /usr/src/calc
COPY package.json .
RUN npm install
COPY . .
# EXPOSE 3000
CMD [ "node", "calculator.js" ]