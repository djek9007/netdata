FROM nginx:alpine
RUN apk add --no-cache apache2-utils bash
COPY default.conf /etc/nginx/conf.d/default.conf
COPY start.sh /start.sh
RUN chmod +x /start.sh
CMD ["/start.sh"]
