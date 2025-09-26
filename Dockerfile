FROM python:3.11-alpine3.22 AS builder

ARG ANSIBLE_VERSION='latest'

RUN set -eux \
    && MAJOR_VERSION="$( echo "${ANSIBLE_VERSION}" | awk -F'.' '{print $1}' )" \
    && MINOR_VERSION="$( echo "${ANSIBLE_VERSION}" | awk -F'.' '{print $2}' )" \
    && PATCH_VERSION="$( echo "${ANSIBLE_VERSION}" | awk -F'.' '{print $3}' )" \
    && REGEX_VERSION='^[[:digit:]]' \
    \
    && if [ "${ANSIBLE_VERSION}" = 'latest' ]; then \
        pip3 install --no-cache-dir ansible; \
    elif echo "${PATCH_VERSION}" | grep -Eq "${REGEX_VERSION}"; then \
        pip3 install --no-cache-dir ansible=="${ANSIBLE_VERSION}"; \
    elif echo "${MINOR_VERSION}" | grep -Eq "${REGEX_VERSION}"; then \
        pip3 install --no-cache-dir ansible~="${MAJOR_VERSION}.${MINOR_VERSION}"; \
    elif echo "${MAJOR_VERSION}" | grep -Eq "${REGEX_VERSION}"; then \
        pip3 install --no-cache-dir ansible~="${MAJOR_VERSION}.0"; \
    else \
        fail; \
    fi

RUN set -eux \
    && apk add --update --no-cache \
        coreutils \
        g++ \
        gcc \
        krb5-dev \
        make \
        musl-dev \
    \
    && pip3 install --no-cache-dir \
        pywinrm \
        pywinrm[credssp] \
        pywinrm[kerberos]

RUN set -eux \
    && pip3 uninstall --yes \
        setuptools \
        wheel

FROM python:3.11-alpine3.22
LABEL maintainer='Anton Melekhin'

RUN set -eux \
    && apk add --no-cache \
        git \
        openssh-client

COPY --from=builder /usr/local/lib/python3.11/site-packages/ /usr/local/lib/python3.11/site-packages/
COPY --from=builder /usr/local/bin/ansible* /usr/local/bin/
