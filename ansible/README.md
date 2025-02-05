# DevOps

# Question 3-1 Document your inventory and base commands

- Le setup nous permet de définir les variables globales, les utilisateurs et les clés privées pour les connexions SSH
- ansible all -i inventories/setup.yml -m ping
- ansible all -i inventories/setup.yml -m setup -a "filter=ansible_distribution*"
- ansible all -i inventories/setup.yml -m apt -a "name=apache2 state=absent" --become


```yml

all:
 vars: # Variables
   ansible_user: admin # User
   ansible_ssh_private_key_file: /home/evlacy/cpe/s8/devops/id_rsa # Private key
 children: # Groups
   prod: # Production
     hosts: admin@ahmet.altinel.takima.cloud # Host

```

