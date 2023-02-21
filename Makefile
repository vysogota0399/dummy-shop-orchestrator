start:
	docker run --rm -it -v `pwd`:/usr/src/app -p 3010:3000 test_app ash

start_server:
	docker run --rm -it -v `pwd`:/usr/src/app -p 3000:9292 test_app bundle exec rackup --host=0.0.0.0

build:
	docker buildx build --platform=linux/arm64 -t test_app .