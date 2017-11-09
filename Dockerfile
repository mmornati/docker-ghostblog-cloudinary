#
# Ghost blog.mornati.net
#

#Build step for Ghost Plugins
FROM node:6-alpine as plugin-builder
WORKDIR /builder
RUN npm install cloudinary-store --production --loglevel=error && \
  mv node_modules/cloudinary-store ./cloudinary-store && \
  cd cloudinary-store && \ 
  npm install --production --loglevel=error

#Create the Docker Ghost Blog
FROM mmornati/docker-ghostblog:1.17.1
LABEL maintainer="Marco Mornati <marco@mornati.net>"

#Install Cloudinary Store into the internal modules
COPY --from=plugin-builder --chown=node /builder/cloudinary-store $GHOST_INSTALL/current/core/server/adapters/storage/cloudinary-store
COPY --chown=node config.production.json $GHOST_INSTALL
