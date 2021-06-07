#!/bin/bash -e

docker stop $(docker ps -a | grep bee | awk '{print $1}')

docker rm $(docker ps -a | grep bee | awk '{print $1}')

mv /root/deploy/ /root/deploy_bak
rm -rf /root/swarm

scp 

./swarm/config62/boot_upgrade.sh
cd deploy
nohup ./deploy_bee.sh 1 30 &

tail -f nohup.out