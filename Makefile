REGISTRY = cimesi/janez:0.2

run:
	hugo server
	
run/container:
	docker run -it --rm -p 8000:80 ${REGISTRY}

build:
	hugo
	docker build -t ${REGISTRY} .

push:
	docker push ${REGISTRY}
