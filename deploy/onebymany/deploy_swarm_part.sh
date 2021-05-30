#!/bin/bash -e
echo "================ 1. 安装配置docker & docker-compose基础环境 ================"

echo "卸载旧的docker"
sudo yum remove -y docker \
 docker-client \
 docker-client-latest \
 docker-common \
 docker-latest \
 docker-latest-logrotate \
 docker-logrotate \
 docker-engine

echo "卸载docker依赖"
sudo yum remove -y docker-ce docker-ce-cli containerd.io

echo "删除docker依赖lib"
sudo rm -rf /var/lib/docker

echo "安装工具包"
sudo yum install -y yum-utils

echo "设置镜像仓库"
sudo yum-config-manager \
    --add-repo \
    https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

echo "安装docker并启动"
sudo yum install -y docker-ce docker-ce-cli containerd.io
sudo systemctl start docker
sudo systemctl enable docker

echo "校验docker并查询版本"
sudo docker --version

echo "安装Docker-Compose"
if [ -L "/usr/bin/docker-compose" ]
    then echo "docker-compose ln exist"
else
    echo "docker-compose ln not exist"
	sudo curl -L "https://github.com/docker/compose/releases/download/1.28.6/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod a+x /usr/local/bin/docker-compose
    sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
fi

echo "校验docker-compose并查询版本"
docker-compose -v
echo "================ 安装配置docker & docker-compose基础环境 完毕 ================"

sleep 3


echo "=============== 分区 ================"
./part.sh

N_LIST=($(nvme list | grep "nvme" | cut -d " " -f 1 || true))
N_ONE=${#NVME_LIST[0]}
UUID=$(blkid -s UUID -o value "$N_ONE")

echo "=============== 挂载磁盘uuid  $UUID  =================="
echo "=============== 重置docker默认存储路径  $UUID  =================="

if [ "$UUID" -ne "" ] 
    then  
        if [ ! -f /etc/docker/daemon.json ]
            then 
                cp resource/daemon.json /etc/docker/daemon.json

                old=\\/www\\/docker
                new=\\/mnt\\/disks\\/$UUID
                sed -i "s/$old/$new/g" /etc/docker/daemon.json
        if
        
else 
    echo "挂载磁盘uuid 不存在"
fi

echo "=============== 重置docker默认存储路径 完毕 重启docker  =================="
sudo systemctl restart docker

echo "================ 2. 构建节点目录和配置文件信息 ================"

mkdir -p bee && cd bee
cp ../resource/docker-compose-many.yml ./
cp ../resource/.env ./
docker-compose -f docker-compose.yml --env-file .env up -d
cd ../
done
echo "================ 构建节点并部署 完毕 ================"



echo "================ 3. 设置自动兑换支票crond ================"

echo "创建crondjob log文件"
touch cashout_log.log

echo "0 0 1 * * ? root /root/deploy/cashout/cashout_proc.sh" >> /var/spool/cron/root
echo "每天凌晨1点全自动提交出票"

service crond status
echo "启动脚本"

echo "================ 设置自动兑换支票crond 完毕 ================"