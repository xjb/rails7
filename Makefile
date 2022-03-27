RUN=docker compose run --rm --entrypoint ''


build: build-ap
	docker compose build

build-ap:
	docker compose build ap

db-migrate:
	${RUN} dev bin/rails db:create db:migrate

db-reset:
	${RUN} dev bin/rails db:migrate:reset

# %:
# 	echo "$@"
