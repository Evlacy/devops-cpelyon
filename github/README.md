# DevOps

# Question 2-1 What are testcontainers?

- Les testcontainers sont des conteneurs Docker qui sont utilisés pour les tests unitaires et d'intégration
- Ca permet de tester le code, les services, les bases de données, les applications... dans un environnement isolé et contrôlé
- Utilisé pour des services externes comme les bases de données, les services web...

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
      - uses: actions/checkout@v2.5.0  # Action: effectuer un checkout du code

      - name: Set up JDK 21  
        uses: actions/setup-java@v3  # Action: installer et configurer Java
        with:
          distribution: 'adopt'  # Choix de la distribution Java (Adoptium)
          java-version: '21'  # Version 

      - name: Build and test with Maven  # Nom de l'étape
        run: mvn -B package --file simple-api/pom.xml  # Commande Maven pour construire le projet
        # -B : mode batch 
        # --file : indique le chemin spécifique du fichier
```

# Question 2-3 For what purpose do we need to push docker images?

- Pour stocker les images Docker
- Pour les partager avec d'autres utilisateurs
- Pour les déployer sur des serveurs

# Question 2-4 Document your quality gate configuration.