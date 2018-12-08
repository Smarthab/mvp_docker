NAME=`cat docker_name`
DCKRNAME=$(NAME)_docker

build:
	docker build -t $(DCKRNAME) .

build-nocache:
	docker build --no-cache -t $(DCKRNAME) .

run:
	docker run --rm --name $(NAME) $(DCKRNAME) $(account) $(uri)
