ARG RUBY_VERSION=3.1.2
FROM ruby:${RUBY_VERSION}

RUN gem update --system &&\
    gem cleanup

# for yarn
ARG NODE_MAJOR=17
RUN curl -sSL https://deb.nodesource.com/setup_${NODE_MAJOR}.x | bash - &&\
    curl -sSL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - &&\
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
# for mssql
RUN curl -sSL https://packages.microsoft.com/keys/microsoft.asc | apt-key add - &&\
    curl -sSL https://packages.microsoft.com/config/debian/$(. /etc/os-release && echo ${VERSION_ID})/prod.list -o /etc/apt/sources.list.d/mssql-release.list

RUN \
    apt-get update &&\
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        # for yarn
        nodejs yarn \
        # for mssql
        freetds-dev \
    &&\
    apt-get clean && rm -rf /var/lib/apt/lists/*

ARG APP_HOME=/app
WORKDIR ${APP_HOME}

COPY . .

RUN if [ -f Gemfile ]; then \
        bundle config set without "development test";\
        bundle install;\
    fi

ENV RAILS_ENV production
ARG RAILS_MASTER_KEY
RUN if [ -x bin/rails ]; then \
        bin/rails assets:precompile assets:clean;\
        DISABLE_BOOTSNAP=1 bin/rails tmp:clear tmp:create;\
    fi

EXPOSE 3000
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
