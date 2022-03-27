FROM curlimages/curl AS downloader
WORKDIR /downloads
# for yarn
RUN curl -sL https://deb.nodesource.com/setup_lts.x -O
RUN curl -s https://dl.yarnpkg.com/debian/pubkey.gpg -O
# for mssql
RUN curl -s https://packages.microsoft.com/keys/microsoft.asc -O
RUN curl -s https://packages.microsoft.com/config/debian/11/prod.list -o mssql-release.list


FROM ruby:3.1.1

COPY --from=downloader /downloads/* /tmp
RUN \
    # for yarn
    cat /tmp/setup_lts.x | bash - ;\
    cat /tmp/pubkey.gpg | apt-key add - ;\
    # for mssql
    cat /tmp/microsoft.asc | apt-key add - ;\
    \
    # for yarn
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list ;\
    # for mssql
    cat /tmp/mssql-release.list | tee /etc/apt/sources.list.d/mssql-release.list ;\
    \
    apt-get update ;\
    apt-get install -y --no-install-recommends \
        # for yarn
        nodejs yarn \
        # for mssql
        freetds-dev \
    ;\
    apt-get clean; rm -rf /var/lib/apt/lists/*

ARG APP_HOME=/app

WORKDIR ${APP_HOME}

COPY . .

RUN if [ -f Gemfile ]; then bundle install; fi

EXPOSE 3000
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
