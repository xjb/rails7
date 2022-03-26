FROM ruby:3.1.1

ARG APP_HOME=/app

WORKDIR ${APP_HOME}

COPY . .

RUN if [ -f Gemfile ]; then bundle install; fi
