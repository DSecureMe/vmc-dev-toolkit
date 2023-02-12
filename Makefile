SHELL = /bin/bash
COMPOSE_DEMO= vmc-demo/compose
DEV_COMPOSE = compose
VENV_PATH = venv

define compose-file-demo
	-f $(COMPOSE_DEMO)/docker-compose.$(1).yml
endef

define compose-file
	-f $(DEV_COMPOSE)/docker-compose.$(1).yml
endef

VMC_BASE = $(call compose-file-demo,postgresql) $(call compose-file-demo,elk) $(call compose-file-demo,vmc) $(call compose-file,vmc-dev) $(call compose-file-demo,ralph)
VMC = $(VMC_BASE) $(call compose-file-demo,hive) $(call compose-file-demo,elastalert) $(call compose-file-demo,ralph)

all:
	@cat README.md

build:
	@echo "Starting to build vmc"
	docker build -t vmc_dev -f Dockerfile.vmc-dev .

test:
ifdef tox
	cd vmc && tox
endif
ifdef module
	source $(VENV_PATH)/bin/activate && export ELASTICSEARCH_URL='127.0.0.1:9200' && cd vmc/src/ && python3 -m vmc test $(module) --settings vmc.config.test_settings -v 2  |grep -v "python3.9/site-packages/elasticsearch_dsl*"
else ifdef all
	source $(VENV_PATH)/bin/activate && export ELASTICSEARCH_URL='127.0.0.1:9200' && cd vmc/src/  && python3 -m vmc test --settings vmc.config.test_settings -v 2
else
	source $(VENV_PATH)/bin/activate && cd vmc/src/ && python3 -m vmc test --settings vmc.config.test_settings -v 2
endif

up:
	#sudo sysctl -w vm.max_map_count=262144
	docker compose --env-file vmc-demo/.env $(VMC) config
ifdef elastic
	docker compose --env-file vmc-demo/.env $(call compose-file-demo,elk) up
endif
ifdef all
	sudo sysctl -w vm.max_map_count=262144
	docker compose --env-file vmc-demo/.env $(VMC) up
else
	docker compose --env-file vmc-demo/.env $(VMC_BASE) up
endif

prepare-dev:
	rm -rf env
	virtualenv $(VENV_PATH)
	source $(VENV_PATH)/bin/activate && pip3 install -r vmc/requirements.txt -r vmc/test_requirements.txt

migrations:
	source $(VENV_PATH)/bin/activate && cd vmc/src/ && python3 -m vmc makemigrations --settings vmc.config.test_settings

demodata:
	@chmod +x vmc-demo/config/demo_data.sh
	@vmc-demo/config/demo_data.sh

down:
	docker compose --env-file vmc-demo/.env $(VMC) down

clean-images:
	@echo "Deleting all containers"
	docker rm -f `docker ps -a -q` 2>/dev/null; true
	@echo "Deleting all images"
	docker rmi -f `docker images -q` 2>/dev/null; true

clean-volumes:
	@echo "Deleting all volumes"
	echo "y" | docker volume prune

clean: clean-images clean-volumes
	@echo "Deleting all networks"
	echo "y" | docker network prune
	@echo "Cleaning the rest"
	echo "y" | docker system prune

.PHONY: all