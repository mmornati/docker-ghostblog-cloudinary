#
# Ghost blog.mornati.net
#

#Build step for Ghost Plugins
FROM node:6.11.3-alpine as plugin-builder
WORKDIR /builder
RUN npm install cloudinary-store --production --loglevel=error && \
  mv node_modules/cloudinary-store ./cloudinary-store && \
  cd cloudinary-store && \ 
  npm install --production --loglevel=error

#Create the Docker Ghost Blog
FROM mmornati/docker-ghostblog:1.10.0
LABEL maintainer="Marco Mornati <marco@mornati.net>"

#Install Cloudinary Store into the internal modules
COPY --from=plugin-builder /builder/cloudinary-store /ghost/blog/versions/1.10.0/core/server/adapters/storage/cloudinary-store
COPY config.production.json /ghost/blog

# Set environment variables.
ENV NODE_ENV production

# Expose ports.
EXPOSE 2368

#HealthCheck
HEALTHCHECK --interval=5m --timeout=3s \
  CMD echo "GET / HTTP/1.1" | nc -v localhost 2368 || exit 1

# Define mountable directories.
VOLUME ["/ghost-override"]

# Define default command.
CMD ["/bin/sh", "/ghost/run-ghost.sh"]
