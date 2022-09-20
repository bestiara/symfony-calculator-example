init: \
	docker-clean \
	up \
	composer-install

up:
	docker-compose up --build -d

stop:
	docker-compose stop

database-init: \
	migrations \
	migrations-test \
	fixtures

docker-clean:
	docker-compose down -v --remove-orphans

.PHONY: migrations
migrations:
	docker-compose run --rm php-cli bin/console doctrine:database:drop --if-exists --force
	docker-compose run --rm php-cli bin/console doctrine:database:create -n -v
	docker-compose run --rm php-cli bin/console doctrine:migrations:migrate -n -v

migrations-test:
	docker-compose run --rm php-cli bin/console doctrine:database:drop --env=test --if-exists --force
	docker-compose run --rm php-cli bin/console doctrine:database:create --env=test -n -v
	docker-compose run --rm php-cli bin/console doctrine:migrations:migrate --env=test -n -v

migration-diff:
	docker-compose run --rm php-cli bin/console doctrine:migration:diff

fixtures:
	docker-compose run --rm php-cli bin/console doctrine:fixtures:load -n -v --no-debug

cache-clear:
	docker-compose run --rm php-cli bin/console cache:clear
	docker-compose run --rm php-cli bin/console cache:clear --no-debug
	docker-compose run --rm php-cli bin/console cache:clear --env=test

composer-install:
	docker-compose run --rm php-cli composer install

composer-update:
	docker-compose run --rm php-cli composer update

test:
	docker-compose run --rm php-cli bin/phpunit --testsuite unit,integration
