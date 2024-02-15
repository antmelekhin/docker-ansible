# Docker images for running Ansible

## Build

```bash
docker build --build-arg='ANSIBLE_VERSION=9' -t antmelekhin/docker-ansible:9 -f Dockerfiles/ansible.Dockerfile .
docker build --build-arg='ANSIBLE_VERSION=latest' -t antmelekhin/docker-ansible:latest -f Dockerfiles/ansible.Dockerfile .
docker build -t antmelekhin/docker-ansible:9-pywinrm -f Dockerfiles/pywinrm.Dockerfile .
docker build -t antmelekhin/docker-ansible:latest-pywinrm -f Dockerfiles/pywinrm.Dockerfile .
```

## Run ansible-playbook

```bash
docker run --rm -t antmelekhin/docker-ansible:9 ansible-playbook -i inventory.yml playbook.yml
docker run --rm -t antmelekhin/docker-ansible:9-pywinrm ansible-playbook -i win_inventory.yml win_playbook.yml
```
