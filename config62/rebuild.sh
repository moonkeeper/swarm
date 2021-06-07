#!/bin/bash -e

bee_dir=$(ls | grep bee_)
for bee in $bee_dir; do
	cd $bee
	sed -i "s/172.21.0.2/clef-1/" bee_config.yml

	docker-compose -f bee_config.yml --env-file .env up -d

	echo "$bee 重建完毕"
	cd ../
done