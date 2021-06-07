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
	##sudo curl -L "https://github.com/docker/compose/releases/download/1.28.6/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

    sudo curl -L "https://get.daocloud.io/docker/compose/releases/download/1.28.6/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod a+x /usr/local/bin/docker-compose
    sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
fi

echo "校验docker-compose并查询版本"
docker-compose -v
echo "================ 安装配置docker & docker-compose基础环境 完毕 ================"