.PHONY: build push login

REPO := ghcr.io/nicholasjackson/workshop-vault-k8s
VERSION ?= v0.1.0

build:
	docker build --load -t $(REPO):$(VERSION) .

push:
	docker build --push -t $(REPO):$(VERSION) .

login:
	@echo "Logging into GitHub Container Registry..."
	@echo "Run: echo \$$GITHUB_TOKEN | docker login ghcr.io -u USERNAME --password-stdin"

packer-build:
	cd packer && packer build -var-file=./main.pkvars.hcl ./main.pkr.hcl