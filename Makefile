# vim: noexpandtab :

COPILOT_APP := realne-auth
COPILOT_ENV := test
ECR_WEBAPP := "151874643243.dkr.ecr.us-west-2.amazonaws.com/realne-auth/webapp:latest"

test:
	vendor/bin/phpunit

phpcs:
	vendor/bin/phpcs --standard=PSR2 app tests

coverage:
	vendor/bin/phpunit --coverage-html tmp/coverage

ecs-migrate:
	copilot task run \
		--app $(COPILOT_APP) \
		--env $(COPILOT_ENV) \
		--image $(ECR_WEBAPP) \
		--entrypoint php \
		--command "artisan key:generate --show"

ecs-cache-clear:
	copilot task run \
		--app $(COPILOT_APP) \
		--env $(COPILOT_ENV) \
		--image $(ECR_WEBAPP) \
		--entrypoint php \
		--command "artisan cache:clear"

