# Builder
FROM nginx:1.27.0-alpine

WORKDIR /root

# install req
RUN apk update && apk add curl openssl socat

# install acme.sh
RUN curl https://get.acme.sh | sh
RUN chmod +x /root/.acme.sh/acme.sh
RUN touch /root/.bashrc
RUN echo "export PATH=$PATH:/root/.acme.sh" >> .bashrc

# nkdir logs
RUN mkdir -p /etc/nginx/logs
RUN touch /etc/nginx/logs/access.log

# add entrypoint.sh
ADD ./docker/entrypoint.sh .
RUN chmod +x /root/entrypoint.sh

# expose
VOLUME ["/cert", "/etc/nginx/conf.d", "/etc/nginx/nginx.conf"]
CMD ["/root/entrypoint.sh"]
