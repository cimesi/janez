REGISTRY ?= cimesi/janez
S3_ENDPOINT ?= https://s3.canada.cime.si:9000
S3_ACCESS_KEY ?= janez-static-page
S3_SECRET_KEY ?= secret
S3_BUCKET ?= janez-static-page

run:
	hugo server
	
image:
	docker build -t ${REGISTRY}:builder --target builder .
	docker build -t ${REGISTRY}:pusher --target pusher .
	docker push ${REGISTRY}:builder
	docker push ${REGISTRY}:pusher

build:
	hugo

publish:
	mc config host add janez-static-page ${S3_ENDPOINT} ${S3_ACCESS_KEY} ${S3_SECRET_KEY}
	mc rm --recursive --force janez-static-page/${S3_BUCKET} || true
	mc cp --recursive public janez-static-page/${S3_BUCKET}
