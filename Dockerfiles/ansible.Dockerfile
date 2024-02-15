FROM python:3.11-alpine3.18 AS builder

ARG ANSIBLE_VERSION='latest'
RUN set -eux \
    && MAJOR_VERSION="$( echo "${ANSIBLE_VERSION}" | awk -F'.' '{print $1}' )" \
    && MINOR_VERSION="$( echo "${ANSIBLE_VERSION}" | awk -F'.' '{print $2}' )" \
    && PATCH_VERSION="$( echo "${ANSIBLE_VERSION}" | awk -F'.' '{print $3}' )" \
    && REGEX_VERSION='^[[:digit:]]' \
    \
    && if [[ "${ANSIBLE_VERSION}" == 'latest' ]]; then \
        pip3 install --no-cache-dir ansible; \
    elif [[ "${PATCH_VERSION}" =~ ${REGEX_VERSION} ]]; then \
        pip3 install --no-cache-dir ansible=="${ANSIBLE_VERSION}"; \
    elif [[ "${MINOR_VERSION}" =~ ${REGEX_VERSION} ]]; then \
        pip3 install --no-cache-dir ansible~="${MAJOR_VERSION}.${MINOR_VERSION}"; \
    elif [[ "${MAJOR_VERSION}" =~ ${REGEX_VERSION} ]]; then \
        pip3 install --no-cache-dir ansible~="${MAJOR_VERSION}.0"; \
    else \
        fail; \
    fi

RUN set -eux \
    && pip3 uninstall --yes \
        setuptools \
        wheel

FROM python:3.11-alpine3.18
LABEL maintainer='Anton Melekhin'

COPY --from=builder /usr/local/lib/python3.11/site-packages/ /usr/local/lib/python3.11/site-packages/
COPY --from=builder /usr/local/bin/ansible* /usr/local/bin/
