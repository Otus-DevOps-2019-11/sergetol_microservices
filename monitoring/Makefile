APP_IMAGES := ui post comment
AUX_IMAGES := prometheus mongodb-exporter cloudprober
ALL_COMMANDS := build push config up down

ifeq '$(strip $(USER_NAME))' ''
  $(warning Variable USER_NAME is not defined, using value 'user')
  USER_NAME := user
endif

ENV_FILE := $(shell test -f ../docker/.env && echo '../docker/.env' || echo '../docker/.env.example')

build: $(APP_IMAGES) $(AUX_IMAGES)

$(APP_IMAGES):
	cd ../src/$(subst post,post-py,$@); bash docker_build.sh; cd -

$(AUX_IMAGES):
	docker build -t $(USER_NAME)/$@ ./$@

push:
ifneq '$(strip $(DOCKER_HUB_PASSWORD))' ''
	@docker login -u $(USER_NAME) -p $(DOCKER_HUB_PASSWORD)
	$(foreach i,$(APP_IMAGES) $(AUX_IMAGES),docker push $(USER_NAME)/$(i);)
else
	@echo 'Variable DOCKER_HUB_PASSWORD is not defined, cannot push images'
endif

config up down:
	docker-compose --env-file $(ENV_FILE) -f ../docker/docker-compose.yml $(subst up,up -d,$@)

$(APP_IMAGES) $(AUX_IMAGES) $(ALL_COMMANDS): FORCE

FORCE:
