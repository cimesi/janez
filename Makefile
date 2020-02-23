REGISTRY = cimesi/janez:latest

build:
	hugo
	docker build -t ${REGISTRY} .

run:
	docker run -it --rm -p 8000:80 ${REGISTRY}

push:
	docker push ${REGISTRY}
