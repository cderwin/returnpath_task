project := returnpath_task
registry := cderwin
image_name := $(project)
tag := $(shell echo "latest")
image := $(registry)/$(project):$(tag)

.PHONY: run sh build push-image deploy-minikube

.ts.container: app.py Pipfile Pipfile.lock Dockerfile
	docker build . -t $(image_name) && \
	touch $@

run: .ts.container
	docker run --rm \
		-p 8000:8000 \
		$(image_name)

sh: $(executable)
	docker run --rm -it \
		-v $$(pwd):/src \
		-p 8000:8000 \
		$(image_name) \
		sh

build: .ts.container

push-image:
	docker build . -t $(image)  && \
	docker push $(image)
