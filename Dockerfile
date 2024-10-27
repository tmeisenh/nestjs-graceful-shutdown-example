FROM node:22.1-alpine3.18 AS base

# -- INSTALL -- #
FROM base as dev-dependencies
ARG build_dir='.'
WORKDIR /project/app
COPY ./${build_dir}/package*.json ./
RUN npm install --no-fund

# -- app source -- #
FROM dev-dependencies as src
WORKDIR /project/app
ARG build_dir='.'
COPY ./${build_dir} ./

# -- BUILD -- #
FROM src as build
RUN npm run build

# -- TEST -- #
FROM src as unit-test
RUN npm run test --ci

# -- TEST -- #
FROM src as e2e-test
RUN npm run test:e2e --ci

# -- LINT -- #
FROM src as lint
RUN npm run lint

# ----- PUBLISH ----- #
FROM base AS publish
ARG build_dir='.'
WORKDIR /project/app
COPY ./${build_dir}/package*.json GIT_* ./
RUN npm install --production --no-fund
COPY --from=build /project/app/dist ./dist
EXPOSE 3000
# very important for graceful shutdown
CMD [ "node", "dist/main.js" ]
