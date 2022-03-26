FROM curlimages/curl AS downloader
WORKDIR /downloads
RUN curl -sL https://deb.nodesource.com/setup_lts.x -O
RUN curl -s https://dl.yarnpkg.com/debian/pubkey.gpg -O


FROM ruby:3.1.1

COPY --from=downloader /downloads/* /tmp
RUN \
    # for webpacker
    cat /tmp/setup_lts.x | bash - ;\
    cat /tmp/pubkey.gpg | apt-key add - ;\
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list ;\
    apt-get update ;\
    apt-get install -y --no-install-recommends nodejs yarn ;\
    apt-get clean; rm -rf /var/lib/apt/lists/*

ARG APP_HOME=/app

WORKDIR ${APP_HOME}

COPY . .

RUN if [ -f Gemfile ]; then bundle install; fi

EXPOSE 3000
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
