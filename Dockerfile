#
# Static homepage
#
FROM nginx:1.17
MAINTAINER cimesi-dockerhub@cime.si

USER root

COPY public /usr/share/nginx/html

# Expose ports
EXPOSE 80
