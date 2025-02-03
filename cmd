# docker build -t proxy .
# docker run -d -p "80:80" --network app-network --name proxy-container proxy

# docker network connect app-network proxy-container
# docker network inspect app-network

ServerName localhost

<VirtualHost *:80>
    ProxyPreserveHost On
    ProxyPass / http://simpleapistudent-container:8080/
    ProxyPassReverse / http://simpleapistudent-container:8080/
</VirtualHost>