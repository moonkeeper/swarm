#!/bin/bash -e
echo "下载部署脚本相关资源"

echo "安装 git"
yum install git
git --version

cd /root

if [ ! -x "/root/swarm" ]; then

  git clone https://github.com/moonkeeper/swarm.git

fi

echo "进入swarm目录执行deploy shell"


mkdir -p deploy && cd deploy
cp /root/swarm/deploy/deploy_swarm.sh ./
chmod a+x deploy_swarm.sh

cp -r /root/swarm/resource ./

cp -r /root/swarm/cashout ./
chmod -R a+x cashout


./deploy_swarm.sh $1 $2
