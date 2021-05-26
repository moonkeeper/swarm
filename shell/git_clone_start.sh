#!/bin/bash
echo "下载部署脚本相关资源"

if [ ! -x "/root/swarm" ]; then

  git clone https://github.com/moonkeeper/swarm.git

fi

echo "进入swarm目录执行deploy shell"
cd /root/swarm/deploy
chmod a+x deploy_swarm.sh
./deploy_swarm.sh $1
