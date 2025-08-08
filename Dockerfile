FROM node:20.11.1 AS build

WORKDIR /usr/src/app

COPY package.json yarn.lock ./
COPY .yarn ./.yarn

COPY . .

RUN yarn run build
RUN yarn workspaces focus --production && yarn cache clean

FROM node:20.11.1-alpine AS production

WORKDIR /usr/src/app

COPY --from=build /usr/src/app/package.json ./package.json
COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/node_modules ./node_modules

EXPOSE 3000

CMD ["yarn", "run", "start:prod"]