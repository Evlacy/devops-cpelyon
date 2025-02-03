# DevOps-CPElyon

- docker build -t evlacy/myfirstapp .
- docker run -p 8888:5000 --name myfirstapp evlacy/myfirstapp
- docker-machine ip default

# Question 1-1 Why should we run the container with a flag -e to give the environment variables?
Pour donner les variables d'environnement au conteneur pour que l'application fonctionne correctement et puisse se connecter à la base de données et à d'autres services nécessaires. De plus, on évite de mettre les informations sensibles dans le code source

# Question 1-2 Why do we need a volume to be attached to our postgres container?
Un volume permet de conserver les données de la base de données même si le conteneur est arrêté ou supprimé. Sinon, les données seraient perdues à chaque redémarrage du conteneur 

# Question 1-3 Document your database container essentials: commands and Dockerfile.

## Dockerfile

FROM postgres:14.1-alpine

ENV POSTGRES_DB=db \
   POSTGRES_USER=us \
   POSTGRES_PASSWORD=pwd

COPY ./initdb-scripts/*.sql /docker-entrypoint-initdb.d/

# Build et run

- docker build -t custom-postgres-db .
- docker network create app-network
- docker run -d --name custom-postgres-container -v "C:/Users/altin/Documents/2023-2026 - CPE/S8/DevOps/devops-cpelyon/tp-docker/data:/var/lib/postgresql/data" --net=app-network -p 5432:5432 custom-postgres-db

## Vérifier la connexion 

- docker run -p "8090:8080" --net=app-network --name=adminer -d adminer 
- Via le navigateur : http://localhost:8090 -> adminer, serveur custom-postgres-container, user us, pwd pwd, db db

# Question 1-4 Why do we need a multistage build? And explain each step of this Dockerfile.

Un multi-stage build dans Docker est utilisé pour réduire la taille de l'image finale et séparer les étapes de construction et d'exécution, ça de réduit la taille des images, améliore la sécurité, simplifie la gestion 

## Dockerfile

FROM maven:3.9.9-amazoncorretto-21 AS myapp-build 
-> On utilise une image maven pour construire l'application

ENV MYAPP_HOME=/opt/myapp 
-> On définit une variable d'environnement pour le répertoire de l'application

WORKDIR $MYAPP_HOME 
-> On se place dans le répertoire de l'application

COPY pom.xml . 
-> On copie le fichier pom.xml

COPY src ./src 
-> On copie le répertoire src

RUN mvn package -DskipTests 
-> On construit l'application en sautant les tests

FROM amazoncorretto:21 -> On utilise une image amazoncorretto pour exécuter l'application
ENV MYAPP_HOME=/opt/myapp  -> On définit une variable d'environnement pour le répertoire de l'application
WORKDIR $MYAPP_HOME -> On se place dans le répertoire de l'application
COPY --from=myapp-build $MYAPP_HOME/target/*.jar $MYAPP_HOME/myapp.jar -> On copie le fichier jar de l'étape de build dans l'étape de run

ENTRYPOINT ["java", "-jar", "myapp.jar"] -> On exécute l'application avec la commande java -jar myapp.jar

# Question 1-5 Why do we need a reverse proxy?

- Pour rediriger les requêtes des clients vers les serveurs appropriés
- Pour cacher les serveurs et améliorer les performances
- Pour sécuriser les serveurs en masquant les informations sensibles

# Question 1-6 Why is docker-compose so important?
# Question 1-7 Document docker-compose most important commands. 1-8 Document your docker-compose file.
# Question 1-9 Document your publication commands and published images in dockerhub.
# Question 1-10 Why do we put our images into an online repo?