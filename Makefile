REGISTRY = cimesi/janez:latest

run:
	docker run -it --rm -p 8000:80 ${REGISTRY}

build:
	hugo
	docker build -t ${REGISTRY} .

push:
	docker push ${REGISTRY}
