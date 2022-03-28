FROM rails7_app:latest

ARG USER=developer
ARG UID=1000
ARG GROUP=${USER}
ARG GID=${UID}

RUN \
    apt-get update &&\
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        sudo \
        \
        curl \
        less \
        vim \
        jq \
    &&\
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN \
    if [ "${USER:-root}" != 'root' ]; then \
        groupadd --gid ${GID} ${GROUP} && \
        useradd --create-home --shell /bin/bash --gid ${GROUP} --uid ${UID} ${USER};\
        \
        # Change workdir owner
        chown -R ${USER}:${GROUP} ./ ${GEM_HOME} ./node_modules;\
        \
        # Enable sudo without password
        echo "${USER} ALL=NOPASSWD: ALL" > /etc/sudoers.d/99-developer;\
    fi

RUN \
    apt-get update &&\
    ACCEPT_EULA=Y \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        sqlite3 \
        default-mysql-client \
        postgresql-client \
        mssql-tools18 msodbcsql18 \
    &&\
    apt-get clean && rm -rf /var/lib/apt/lists/*

# mssql-tools
ENV PATH ${PATH}:/opt/mssql-tools18/bin:/opt/mssql-tools/bin

ENV EDITOR vim

USER ${USER}

ENTRYPOINT ["bash", "entrypoint.sh"]
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
