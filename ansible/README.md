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
    ansible_python_interpreter: /usr/bin/python3
  roles: # on appelle les roles
    # - docker
    - network 
    - copy
    - database
    - app
    - proxy
    - front
```

- Tasks network

```yml



# Question 3-3 Document your docker_container tasks configuration.

