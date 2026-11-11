FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    nginx \
    mysql-server \
    && rm -rf /var/lib/apt/lists/*

RUN service mysql start \
    && mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root';" \
    && service mysql stop

RUN sed -i 's/listen 80 default_server;/listen 8080 default_server;/g' /etc/nginx/sites-available/default

RUN echo '#!/bin/bash\nservice mysql start\nnginx -g "daemon off;"' > /start.sh \
    && chmod +x /start.sh

EXPOSE 8080
EXPOSE 3306

CMD ["/start.sh"]