project := returnpath_task
registry := registry.camderwin.us
image_name := $(project)
tag := $(shell echo "latest")
image := $(registry)/$(project):$(tag)

.PHONY: run sh build deploy end

.ts.container: app.py Pipfile Pipfile.lock Dockerfile
	docker build . -t $(image_name) && \
	touch $@

run: .ts.container
	docker run --rm \
		-v $$(pwd)/static:/static \
		-p 8000:8000 \
		$(image_name)

sh: $(executable)
	docker run --rm -it \
		-v $$(pwd)/static:/static \
		-v $$(pwd):/src \
		-p 8000:8000 \
		$(image_name) \
		sh

build: .ts.container

deploy: $(executable)
	docker build . -t $(image)  && \
	docker push $(image)
