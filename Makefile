RUN=docker compose run --rm --entrypoint ''

up:
	docker compose up

down:
	- docker compose --profile production --profile debug down

build: build@ap
	docker compose build

build@ap:
	docker compose build ap

build-full:
	docker compose build ap --pull --no-cache
	docker compose build --no-cache

install:
	${RUN} dev bundle install

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

db-migrate: db-migrate@dev

db-migrate@%:
	${RUN} ${*} bin/rails db:create db:migrate

db-reset: db-reset@dev

db-reset@%:
	${RUN} ${*} bin/rails db:migrate:reset

db-drop: db-drop@dev

db-drop@%:
	${RUN} ${*} bin/rails db:drop

precompile: precompile@dev

precompile@%:
	${RUN} ${*} bin/rails assets:clobber assets:precompile

routes:
	${RUN} dev bin/rails routes

tasks:
	${RUN} dev bin/rails --tasks

rails?:
	${RUN} dev bin/rails --help

rails/%:
	${RUN} dev bin/rails ${*}

clean: clean?

clean?:
	git clean -fdx -e .env -e '*compose.override.y*ml' --dry-run

clean!:
	git clean -fdx -e .env -e '*compose.override.y*ml'

merged?:
	git branch --merged | grep -Pv "(^\*|main)" | cat

merged!:
	git branch --merged | grep -Pv "(^\*|main)" | xargs -r git branch -d

# %:
# 	echo "$@ ${@D} ${@F} $< $^ $? $+ $*"

ip:
	echo $(shell hostname -I)

fullpass:
	echo $(addprefix $(shell pwd)/,Makefile)


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
