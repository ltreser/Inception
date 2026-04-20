all:
	mkdir -p ~/data/web ~/data/db
	docker compose -f src/docker-compose.yml up --build -d

down:
	docker compose -f src/docker-compose.yml down

re: fclean all

clean:
	docker compose -f src/docker-compose.yml down --rmi all

fclean:
	docker compose -f src/docker-compose.yml down -v --rmi all
	sudo rm -rf ~/data/web/* ~/data/db/*

.PHONY: all down re clean fclean
