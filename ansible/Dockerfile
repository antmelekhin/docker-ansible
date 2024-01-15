FROM python:3.11-alpine3.18 AS builder

RUN set -eux \
    && apk add --update --no-cache \
        coreutils \
        g++ \
        gcc \
        make \
        musl-dev

ARG ANSIBLE_VERSION='latest'
RUN set -eux \
    && if [ "${ANSIBLE_VERSION}" = 'latest' ]; then \
        pip3 install --no-cache-dir ansible; \
    fi

RUN set -eux \
    && apk add --update --no-cache \
        krb5-dev \
    && pip3 install --no-cache-dir \
        pywinrm \
        pywinrm[credssp] \
        pywinrm[kerberos]

RUN set -eux \
    && pip3 uninstall --yes \
        setuptools \
        wheel

FROM python:3.11-alpine3.18
LABEL maintainer='Anton Melekhin'

COPY --from=builder /usr/local/lib/python3.11/site-packages/ /usr/local/lib/python3.11/site-packages/
COPY --from=builder /usr/local/bin/ansible* /usr/local/bin/
