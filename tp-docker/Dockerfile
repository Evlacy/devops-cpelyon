FROM postgres:14.1-alpine

ENV POSTGRES_DB=db \
   POSTGRES_USER=us \
   POSTGRES_PASSWORD=pwd

COPY ./initdb-scripts/*.sql /docker-entrypoint-initdb.d/

# docker build -t custom-postgres-db .
# docker network create app-network
# docker run -p 5432:5432 -d -v "C:/Users/altin/Documents/2023-2026 - CPE/S8/DevOps/devops-cpelyon/tp-docker/data:/var/lib/postgresql/data" --name custom-postgres-container --network app-network custom-postgres-db

# dans un autre terminal :   
# docker run -p "8090:8080" --net=app-network --name=adminer -d adminer 

# via le navigateur : http://localhost:8090 -> adminer, serveur custom-postgres-container, user us, pwd pwd, db db
