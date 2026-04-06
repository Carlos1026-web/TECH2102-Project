FROM node:24.14.0-alpine AS builder
WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN CI='' npm run build

FROM nginx:alpine
COPY --from=builder /app/build /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]