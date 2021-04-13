NAME := ka
MYHOME := $(PWD)
VERSION := $(shell cat ./VERSION |awk 'NR==1 { print $1; }')

all: usage

usage:
	@echo "Usage:                                              "
	@echo "                                                    "
	@echo "    make command                                    "
	@echo "                                                    "
	@echo "The commands are:                                   "
	@echo "                                                    "
	@echo "    build       compile packages and dependencies   "
	@echo "    run         start the runner                    "
	@echo "    clean       remove object files                 "
	@echo "    image       build the docker images             "
	@echo "    docker      run a docker container              "
	@echo "    serve       run hugo server to host doc         "
	@echo "    status      run git status                      "
	@echo "    release     release a version                   "
	@echo "                                                    "

run:
	@$(MYHOME)/bin/$(NAME)

serve:
	hugo server --enableGitInfo --watch --source doc

build:
	@cd ka && julia main.jl

jupyter:
	@cd jupyter && jupyter lab

deps:
	julia tools/deps.jl

image:
	docker build -f Dockerfile -t $(NAME)-$(VERSION) .

docker:
	docker run -it $(NAME)-$(VERSION):latest

compose:
	docker-compose -f docker-compose.yml up -d

compose-stop:
	docker-compose stop

.PHONY: clean check distclean jupyter fmt docker test release

clean:
	rm -f $(NAME).svg $(NAME).png $(NAME)/coverage.* trace.out dive.log
	find . -name \*~ -type f |xargs -I {} rm -f {}

distclean: clean
	rm -f $(MYHOME)/bin/$(NAME)
