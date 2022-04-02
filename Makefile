RUN=docker compose run --rm --entrypoint ''


build: build@ap
	docker compose build

build@ap:
	docker compose build ap

up:
	docker compose up

down:
	- docker compose --profile production --profile debug down

install:
	${RUN} dev bundle install

db-migrate: db-migrate@dev

db-migrate@%:
	${RUN} ${*} bin/rails db:create db:migrate

db-reset: db-reset@dev

db-reset@%:
	${RUN} ${*} bin/rails db:migrate:reset

db-drop: db-drop@dev

db-drop@%:
	${RUN} ${*} bin/rails db:drop

routes:
	${RUN} dev bin/rails routes

tasks:
	${RUN} dev bin/rails --tasks

rspec:
	${RUN} dev bundle exec rspec

rubocop:
	${RUN} dev bundle exec rubocop

rubocop-auto-gen-config:
	${RUN} dev bundle exec rubocop --auto-gen-config

rubocop-auto-correct:
	${RUN} dev bundle exec rubocop --auto-correct-all

erblint:
	${RUN} dev bundle exec erblint --lint-all

erblint-auto-correct:
	${RUN} dev bundle exec erblint --lint-all --autocorrect

brakeman:
	${RUN} dev bundle exec brakeman --rails7 --run-all-checks --confidence-level 1

brakeman-interactive-ignore:
	${RUN} dev bundle exec brakeman --rails7 --run-all-checks --confidence-level 1 --interactive-ignore



# Cleanup targets
# ==============================================================================

clean: clean?

clean?:
	git clean -fdx -e .env -e '*compose.override.y*ml' -e 'db/*.sqlite3' --dry-run

clean!:
	git clean -fdx -e .env -e '*compose.override.y*ml' -e 'db/*.sqlite3'

merged: merged?

merged?:
	git branch -vv --merged | grep -Pv "(^\*|main)"

merged!:
	git branch --merged | grep -Pv "(^\*|main)" | xargs -r git branch -d




# Setup targets
# ==============================================================================

rails-install:
	${RUN} dev bundle init
	sed -i -r "s/^# gem \"rails\"/gem \"rails\"/" Gemfile
	${RUN} dev bundle install

rails-new: rm-bundle
	${RUN} dev bundle exec rails new . \
		--database=sqlite3 \
		--skip-test \
		--javascript=webpack
	echo "RAILS_MASTER_KEY=`cat ./config/master.key`" > .env

bootstrap-install:
	${RUN} dev bin/rails css:install:bootstrap

rspec-install:
	${RUN} dev bin/rails generate rspec:install

rubocop-install:
	${RUN} dev bundle exec rubocop --init



# Temporary targets
# ==============================================================================

build-full:
	docker compose build ap --pull --no-cache
	docker compose build --no-cache

rm-bundle: down
	- docker volume rm rails7_bundle

prune: prune?

prune?:
	docker ps --filter status=exited
	@echo
	docker network ls --filter dangling=true
	@echo
	docker image ls --filter dangling=true
	@echo
	docker volume ls --filter dangling=true
	@echo

prune!:
	docker system prune --force
	docker volume prune --force

precompile: precompile@dev

precompile@%:
	${RUN} ${*} bin/rails assets:clobber assets:precompile

rails?:
	${RUN} dev bin/rails --help

rails/credentials/edit:
	${RUN} dev bash -c "EDITOR=vim bin/rails credentials:edit"

rails/credentials/show:
	${RUN} dev bin/rails runner 'puts Rails.application.credentials.config.inspect'

rails/%:
	${RUN} dev bin/rails ${*}

rails/generate?:
	${RUN} dev bin/rails generate --help

# docker compose run --rm --entrypoint '' dev bin/rails g scaffold user name:string email:string
rails/generate/scaffold/%:
	${RUN} dev bin/rails generate scaffold ${*}

rails/destroy?:
	${RUN} dev bin/rails destroy --help

# docker compose run --rm --entrypoint '' dev bin/rails d scaffold user
rails/destroy/%:
	${RUN} dev bin/rails destroy scaffold ${*}

# %:
# 	echo "$@ ${@D} ${@F} $< $^ $? $+ $*"

ip:
	echo $(shell hostname -I)

fullpass:
	echo $(addprefix $(shell pwd)/,Makefile)

bash:
	${RUN} dev bash

bash-exec:
#	docker compose exec dev bash
	docker exec -it `docker ps --filter name=dev --quiet` bash

bash-run-image@dev:
	docker run --rm -it rails7_dev bash

bash-run-image@ap:
	docker run --rm -it rails7_ap bash

attach:
	docker attach `docker ps --filter name=dev --quiet`
