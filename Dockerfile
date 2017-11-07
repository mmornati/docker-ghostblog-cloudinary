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
FROM mmornati/docker-ghostblog:latest
LABEL maintainer="Marco Mornati <marco@mornati.net>"

#Install Cloudinary Store into the internal modules
COPY --from=plugin-builder --chown=node /builder/cloudinary-store $GHOST_INSTALL/current/core/server/adapters/storage/cloudinary-store
RUN ghost config storage.active "cloudinary-store" && \
    ghost config storage.cloudinary-store.configuration.image.quality "auto:good" && \
    ghost config storage.cloudinary-store.configuration.image.secure "true" && \
    ghost config storage.cloudinary-store.configuration.file.use_filename "false" && \
    ghost config storage.cloudinary-store.configuration.file.unique_filename "true" && \
    ghost config storage.cloudinary-store.configuration.file.phash "true" && \
    ghost config storage.cloudinary-store.configuration.file.overwrite "false" && \
    ghost config storage.cloudinary-store.configuration.file.invalidate "true"
