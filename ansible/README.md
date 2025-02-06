# DevOps

# Question 3-1 Document your inventory and base commands

- Le setup nous permet de définir les variables globales, les utilisateurs et les clés privées pour les connexions SSH
- ansible all -i inventories/setup.yml -m ping 
- ansible all -i inventories/setup.yml -m setup -a "filter=ansible_distribution*"
- ansible all -i inventories/setup.yml -m apt -a "name=apache2 state=absent" --become

- "all" : Tous les serveurs
- "-i" : Inventaire
- "-m" : Module
- "-a" : Arguments
- "--become" : Exécuter en tant que super utilisateur

```yml

all:
 vars: # Variables
   ansible_user: admin # User
   ansible_ssh_private_key_file: /home/evlacy/cpe/s8/devops/id_rsa # Private key
 children: # Groups
   prod: # Production
     hosts: admin@ahmet.altinel.takima.cloud # Host

```

# Question 3-2 Document your playbook

- Le playbook permet de définir les tâches à effectuer sur les serveurs
- ansible-playbook -i inventories/setup.yml playbooks/setup.yml
- "-i" : Inventaire
- "playbooks/setup.yml" : Playbook

```yml

- hosts: all # on cible toutes les machines
  gather_facts: true # on récupère les infos sur les machines
  become: true # on passe en root
  vars:
    ansible_python_interpreter: /usr/bin/python3 # on spécifie l'interpréteur Python
  roles: # on appelle les roles
    # - docker
    - network 
    # - copy
    - database
    - app
    - proxy
    - front

```
# Question 3-3 Document your docker_container tasks configuration.

- Network : Création des réseaux

```yml

- name: Create the first network 
  community.docker.docker_network: # on utilise le module docker_network pour creer 1 reseau interne, externe et pour le front (3 réseaux)
    name: appnetwork 

- name: Create the second network
  community.docker.docker_network:
    name: appnetwork2

- name: Create the third network
  community.docker.docker_network:
    name: appnetwork3

```

- Copie du fichier env (ancienne version)

```yml

- name: Copy .env
  ansible.builtin.copy:
    src: /home/evlacy/cpe/s8/devops/devops-cpelyon/ansible/.env # le chemin du fichier source
    dest: /.env  # le chemin de destination
    owner: admin # le propriétaire du fichier
    group: admin # le groupe du fichier
    mode: '0644' # les droits du fichier

```

- Database

```yml

- name: Launch Database Container 
  community.docker.docker_container:
    name: database
    image: evlacy/tp-devops-database:latest # l'image du container dans le Docker Hub
    pull: yes # on demande à Docker de tirer l'image à chaque fois
    env_file: /.env # le fichier d'environnement dans le container
    networks: # les réseaux auxquels le container doit être connecté pour communiquer avec les autres containers
      - name: appnetwork
    volumes:
      - db-volume:/var/lib/postgresql/data # on monte un volume pour la base de données (creer avec le playbookvolumes.yml)

```

- App 

```yml

- name: Launch Application Container # on lance le container de l'application
  community.docker.docker_container: # on utilise le module docker_container de la communauté
    name: simple-api # le nom du container
    image: evlacy/tp-devops-simple-api:latest # l'image du container dans le Docker Hub
    pull: yes # on demande à Docker de tirer l'image à chaque fois
    env_file: /.env # le fichier d'environnement dans le container
    networks: # les réseaux auxquels le container doit être connecté pour communiquer avec les autres containers
      - name: appnetwork 
      - name: appnetwork2

```

- Proxy

```yml

- name: Launch Proxy Container
  community.docker.docker_container:
    name: http-server # le nom du container
    image: evlacy/tp-devops-httpd:latest # l'image du container dans le Docker Hub
    pull: yes # on demande à Docker de tirer l'image à chaque fois
    networks: # les réseaux auxquels le container doit être connecté pour communiquer avec les autres containers
      - name: appnetwork
      - name: appnetwork3
    ports: # les ports à exposer pour accéder à l'application
      - "80:80"
      - "8080:8080"

```

- Front

```yml

- name: Launch Front container
  community.docker.docker_container:
    name: front # le nom du container
    image: evlacy/tp-devops-front:latest # l'image du container dans le Docker Hub
    pull: yes # on demande à Docker de tirer l'image à chaque fois
    networks: # les réseaux auxquels le container doit être connecté pour communiquer avec les autres containers
      - name: appnetwork3

```

