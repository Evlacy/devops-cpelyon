# DevOps

# Question 2-1 What are testcontainers?

- Les testcontainers sont des conteneurs Docker qui sont utilisés pour les tests unitaires et d'intégration
- Ca permet de tester le code, les services, les bases de données, les applications... dans un environnement isolé
- Il est utilisé pour tester les applications qui dépendent de services externes

# Question 2-2 Document your Github Actions configurations.

```yaml
name: CI devops 2025  # Nom du workflow

on:  # Définit les événements qui déclencheront ce workflow
  push:  
    branches: [ main, develop ]  # Limite les déclencheurs aux branches main et develop
  pull_request:  # Lancement également pour chaque pull request créée ou mise à jour

jobs:  # Déclaration des jobs
  test-backend:  # Nom du job
    runs-on: ubuntu-22.04  # Le job sera exécuté sur une Ubuntu 22.04
    
    defaults:
      run:
        working-directory: ./github  # Répertoire de travail 

    steps:  # Liste des étapes du job
      - uses: actions/checkout@v4  # Action: effectuer un checkout du code

      - name: Set up JDK 21  
        uses: actions/setup-java@v4  # Action: installer et configurer Java
        with:
          distribution: 'corretto'  # Choix de la distribution de Java
          java-version: '21'  # Version 

      - name: Build and test with Maven  # Nom de l'étape
        run: mvn -B verify sonar:sonar -Dsonar.projectKey=Evlacy_devops-cpelyon -Dsonar.organization=evlacy -Dsonar.host.url=https://sonarcloud.io -Dsonar.login=${{ secrets.SONAR_TOKEN }}  --file ./pom.xml

        # -B : mode batch 
        working-directory: github/simple-api  # Répertoire de travail
```

# Question 2-3 For what purpose do we need to push docker images?

- Pour stocker les images Docker
- Pour les partager avec d'autres utilisateurs
- Pour les déployer sur des serveurs

# Question 2-4 Document your quality gate configuration.

- SonarQube est un outil d'analyse statique de code source
- Il permet de mesurer la qualité du code source
- Il nous donne des infos sur la qualité du code, les bugs, les vulnérabilités, les codes dupliqués et pleins d'autres trucs
- Il est lancé après la construction du projet Maven
- On peut voir les résultats sur l'interface SonarQube 

```yaml
      - name: Build and test with Maven
        run: mvn -B verify sonar:sonar -Dsonar.projectKey=Evlacy_devops-cpelyon -Dsonar.organization=evlacy -Dsonar.host.url=https://sonarcloud.io -Dsonar.login=${{ secrets.SONAR_TOKEN }} --file ./pom.xml
        working-directory: github/simple-api
```

- `mvn verify sonar:sonar` : commande Maven pour lancer l'analyse SonarQube
- `-Dsonar.projectKey=Evlacy_devops-cpelyon` : clé du projet SonarQube
- `-Dsonar.organization=evlacy` : organisation SonarQube
- `-Dsonar.host.url=https://sonarcloud.io` : URL de l'instance SonarQube
- `-Dsonar.login=${{ secrets.SONAR_TOKEN }}` : token SonarQube stocké dans les secrets GitHub