VERSION := $(shell cat ./VERSION |awk 'NR==1 { print $1; }')
GOMODULES = ./...
NAME := zeta
MYHOME := $(PWD)
GOFILES = $(shell cd $(NAME) && go list $(GOMODULES) |grep -v /vendor/)
BRANCH = $(shell git rev-parse --abbrev-ref HEAD)
COMMIT = $(shell git rev-parse --short HEAD)
LDFLAGS = "-X main.Version=$(NAME)-$(VERSION)-$(BRANCH)-$(COMMIT)"

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
	@echo "    dev         run go build -mod=vendor            "
	@echo "    debug       run go build -tags debug            "
	@echo "    test        run go test                         "
	@echo "    clean       remove object files                 "
	@echo "    fmt         run gofmt on package sources        "
	@echo "    image       build the docker images             "
	@echo "    docker      run a docker container              "
	@echo "    prof        run go tool pprof                   "
	@echo "    wprof       run go tool pprof for web           "
	@echo "    trace       run go tool trace                   "
	@echo "    cov         run go tool cover                   "
	@echo "    godoc       run godoc                           "
	@echo "    serve       run hugo server to host doc         "
	@echo "    status      run git status                      "
	@echo "    release     release a version                   "
	@echo "                                                    "

build:
	cd $(NAME) && CGO_ENABLED=1 go build -ldflags=$(LDFLAGS) -a -o $(MYHOME)/bin/$(NAME)

dev:
	cd $(NAME) && GO111MODULE=on go build -mod=vendor -ldflags=$(LDFLAGS) -o $(MYHOME)/bin/$(NAME)

mod:
	cd $(NAME) && GO111MODULE=on go mod download

debug:
	cd $(NAME) && go build -tags debug -ldflags=$(LDFLAGS) -o $(MYHOME)/bin/$(NAME) -gcflags "all=-N -l"

run:
	@$(MYHOME)/bin/$(NAME)

cov:
	cd $(NAME) && go test -v $(GOMODULES) -coverprofile=coverage.out
	cd $(NAME) && go tool cover -html=coverage.out -o coverage.html

fmt:
	cd $(NAME) && go fmt $(GOFILES)

lint:
	cd $(NAME) && golint $(GOFILES)

test check:
	cd $(NAME)/tests && go test -v -failfast -race -coverpkg=./... -covermode=atomic -coverprofile=coverage.out $(GOFILES) -run . -timeout=2m

static:
	hugo --enableGitInfo --source doc

serve:
	sh tools/init_hugo_themes.sh
	hugo server --enableGitInfo --watch --source doc

bindata: zeta/stdlib/stdlib.ss
	cd $(NAME) && go-bindata -pkg stdlib -o stdlib/stdlib.go stdlib/*.ss

#debugger: go get github.com/go-delve/delve/cmd/dlv
dlv:
	$(GOPATH)/bin/dlv exec bin/$(NAME)

prof:
	go tool pprof -svg --output $(NAME).svg $(MYHOME)/bin/$(NAME) http://127.0.0.1:3721/debug/pprof/profile

wprof:
	find $(HOME)/pprof/pprof.$(NAME).samples.cpu.*.gz |sort -nr |awk 'NR==1 { print $0; }' |xargs -I {} pprof -http=:3722 {}

trace:
	curl http://localhost:3721/debug/pprof/trace\?seconds\=300 > trace.out
	go tool trace -http=:3723 $(MYHOME)/bin/$(NAME) trace.out

autopprof:
	ps -ef |grep zeta |awk 'NR==2 { print $2; }' |xagrs -I {} kill -3 {}

godoc: # pkg
	GOPATH="" godoc -http=:6060

prepare:
	go get github.com/google/pprof
	go get github.com/goreleaser/goreleaser
	go get github.com/go-bindata/go-bindata/...
	go get github.com/wagoodman/dive
	go get github.com/go-delve/delve/cmd/dlv
	go get github.com/poloxue/modv

graph:
	go mod graph |modv |dot -T png -o $(NAME).png

status:
	git status

init:
	cd $(NAME) && GO111MODULE=on go mod init $(NAME)

update:
	cd $(NAME) && GO111MODULE=on go mod download
	cd $(NAME) && GO111MODULE=on go mod vendor

image:
	docker build -f Dockerfile -t $(NAME)-$(VERSION) .

docker:
	docker run -it $(NAME)-$(VERSION):latest

compose:
	docker-compose -f docker-compose.yml up -d

compose-stop:
	docker-compose stop

# https://github.com/wagoodman/dive
dive:
	$(GOPATH)/bin/dive $(NAME)-$(VERSION)

tag:
	git tag -a $(VERSION) -m "Release: $(VERSION)" || true
	git push origin $(VERSION)

# https://goreleaser.com/
release:
	cd $(NAME) && goreleaser release --rm-dist

.PHONE: clean check distclean fmt docker test release

goclean:
	go clean -modcache

clean:
	rm -f $(NAME).svg $(NAME).png $(NAME)/coverage.* trace.out dive.log
	find . -name \*~ -type f |xargs -I {} rm -f {}

distclean: clean
	rm -f $(MYHOME)/bin/$(NAME)
