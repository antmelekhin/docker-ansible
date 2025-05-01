# Docker images for running Ansible

## Build and run

- Build the image

    ```bash
    export ANSIBLE_VERSION='10'
    docker build --build-arg="ANSIBLE_VERSION=${ANSIBLE_VERSION}" -t "docker-ansible:${ANSIBLE_VERSION}" -f Dockerfile .
    ```

- Run ansible-playbook

    ```bash
    docker run --rm -v $(pwd):/ansible -v ~/.ssh/id_rsa:/root/.ssh/id_rsa -t "docker-ansible:${ANSIBLE_VERSION}" ansible-playbook -i inventory.yml playbook.yml
    ```

## License

MIT

## Author

Melekhin Anton.
