FROM nginx:1.17-alpine

# Enable the auto index page
RUN sed -i -e '/location.*\/.*{/a autoindex on\;' /etc/nginx/conf.d/default.conf
