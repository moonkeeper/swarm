#!/bin/bash -e
echo "=========== 部署脚本相关资源 ============="

if [ ! -d "/root/swarm" ]; then
  echo "部署文件目录swarm不存在, 退出部署"
  exit(1)
fi

echo "创建部署节点目录并执行部署"


mkdir -p /root/deploy && cd /root/deploy
cp /root/swarm/deploy/onebymanny/deploy_swarm.sh /root/deploy/deploy_swarm_many.sh
chmod a+x /root/deploy/deploy_swarm_many.sh

cp -r /root/swarm/resource /root/deploy/
cp -r /root/swarm/cashout /root/deploy/
chmod -R a+x /root/deploy/cashout

cd /root/deploy/
./deploy_swarm_many.sh 
