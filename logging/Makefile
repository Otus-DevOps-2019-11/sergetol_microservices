APP_IMAGES := ui post comment
LOG_IMAGES := fluentd
DOCKER_COMMANDS := build push
COMPOSE_COMMANDS := config up down
COMPOSE_COMMANDS_LOG := configlog uplog downlog

ifeq '$(strip $(USER_NAME))' ''
  $(warning Variable USER_NAME is not defined, using value 'user')
  USER_NAME := user
endif

ENV_FILE := $(shell test -f ../docker/.env && echo '../docker/.env' || echo '../docker/.env.example')

build: $(APP_IMAGES) $(LOG_IMAGES)

$(APP_IMAGES):
	cd ../src/$(subst post,post-py,$@); bash docker_build.sh; cd -

$(LOG_IMAGES):
	docker build -t $(USER_NAME)/$@ ./$@

push:
ifneq '$(strip $(DOCKER_HUB_PASSWORD))' ''
	@docker login -u $(USER_NAME) -p $(DOCKER_HUB_PASSWORD)
	$(foreach i,$(APP_IMAGES) $(LOG_IMAGES),docker push $(USER_NAME)/$(i);)
else
	@echo 'Variable DOCKER_HUB_PASSWORD is not defined, cannot push images'
endif

$(COMPOSE_COMMANDS):
	docker-compose --env-file $(ENV_FILE) -f ../docker/docker-compose.yml $(subst up,up -d,$@)

$(COMPOSE_COMMANDS_LOG):
	docker-compose --env-file $(ENV_FILE) -f ../docker/docker-compose-logging.yml $(subst log,,$(subst up,up -d,$@))

$(APP_IMAGES) $(LOG_IMAGES) $(DOCKER_COMMANDS) $(COMPOSE_COMMANDS) $(COMPOSE_COMMANDS_LOG): FORCE

FORCE:
