FROM node:12-alpine as build-server
ENV NODE_ENV=production
RUN apk add --no-cache git bash gettext
ENV SKIP_PREFLIGHT_CHECK=true

WORKDIR /usr/src/server

# Install packages
COPY package.json package.json
COPY yarn.lock yarn.lock

RUN yarn

COPY . .
RUN yarn build

ENTRYPOINT [ "yarn" ]

FROM node:12-alpine as server
ENV NODE_ENV=production
ENV PORT=1337

# Copy the React Front End build files
WORKDIR /usr/src
COPY --from=build-server /usr/src/server .

# Start the server
EXPOSE 1337
CMD [ "node", "server.js" ]
