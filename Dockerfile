FROM node:10.10.0-alpine
WORKDIR /home/app
COPY . .
RUN npm install
EXPOSE 3000
CMD ["npm", "start"]
