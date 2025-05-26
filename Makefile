all: build

build:
	docker builder build -t closehandle/smartdns:latest --network host .

clean:
	docker builder prune -af
