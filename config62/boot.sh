#!/bin/bash -e

cd /root
if [ ! -d "/root/swarm" ]; then
  echo "部署文件目录swarm不存在, 退出部署"
  exit 1
fi

echo "进入swarm目录执行deploy shell"


mkdir -p /root/deploy
cp /root/swarm/config62/deploy_step_part.sh /root/deploy/deploy.sh
cp /root/swarm/config62/deploy_part.sh /root/deploy/deploy_part.sh
cp /root/swarm/config62/deploy_part_m2.sh /root/deploy/deploy_part_m2.sh
cp /root/swarm/config62/deploy_env.sh /root/deploy/deploy_env.sh
cp /root/swarm/config62/deploy_clef.sh /root/deploy/deploy_clef.sh
cp /root/swarm/config62/deploy_bee.sh /root/deploy/deploy_bee.sh
chmod a+x /root/deploy/deploy.sh
chmod a+x /root/deploy/deploy_part.sh
chmod a+x /root/deploy/deploy_part_m2.sh
chmod a+x /root/deploy/deploy_env.sh
chmod a+x /root/deploy/deploy_clef.sh
chmod a+x /root/deploy/deploy_bee.sh

cp /root/swarm/config62/daemon.json /root/deploy/daemon.json

mkdir -p /root/deploy/resource 
cp /root/swarm/config62/clef_config.yml /root/swarm/config62/bee_config.yml /root/swarm/config62/.env /root/deploy/resource

cp -r /root/swarm/cashout /root/deploy/
chmod -R a+x /root/swarm/cashout

chmod a+x /root/swarm/config62/res/nvme-cli-1.14.tar
cp /root/swarm/config62/res/nvme-cli-1.14.tar /usr/local/src

cd /root/deploy
./deploy.sh $1 $2 $3
