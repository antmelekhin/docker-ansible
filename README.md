# Docker images for running Ansible

## Build

```bash
docker build -t docker-ansible:8 -f Dockerfile .
```

## Run ansible-playbook

```bash
docker run --rm -t docker-ansible:8 ansible-playbook -i inventory.yml playbook.yml
```
