#!/bin/bash -e

cd /root
if [ ! -d "/root/swarm" ]; then
  echo "部署文件目录swarm不存在, 退出部署"
  exit 1
fi

echo "进入swarm目录执行deploy shell"


mkdir -p /root/deploy
cp /root/swarm/config53/deploy_step_part.sh /root/deploy/deploy.sh
cp /root/swarm/config53/deploy_part.sh /root/deploy/deploy_part.sh
cp /root/swarm/config53/deploy_env.sh /root/deploy/deploy_env.sh
cp /root/swarm/config53/deploy_clef.sh /root/deploy/deploy_clef.sh
cp /root/swarm/config53/deploy_bee.sh /root/deploy/deploy_bee.sh
chmod a+x /root/deploy/deploy.sh
chmod a+x /root/deploy/deploy_part.sh
chmod a+x /root/deploy/deploy_env.sh
chmod a+x /root/deploy/deploy_clef.sh
chmod a+x /root/deploy/deploy_bee.sh

cp /root/swarm/config53/daemon.json /root/deploy/daemon.json

mkdir -p /root/deploy/resource 
cp /root/swarm/config53/clef_config.yml /root/swarm/config53/bee_config.yml /root/swarm/config53/.env /root/deploy/resource

cp -r /root/swarm/cashout /root/deploy/
chmod -R a+x /root/swarm/cashout

cd /root/deploy
./deploy.sh $1 $2 $3
