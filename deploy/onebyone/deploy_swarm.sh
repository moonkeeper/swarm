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
sudo systemctl restart docker
echo "================ 安装配置docker & docker-compose基础环境 完毕 ================"

sleep 3

echo "================ 2. 构建节点目录和配置文件信息 ================"

echo "创建eth地址文件和bee_debug端口文件"
touch addr.log debug_port.log
echo "创建eth地址文件和bee_debug端口文件  完毕"

node_num=$2
echo "当前创建节点数量 : $node_num"
declare port1=1200
declare port2=1500
declare port3=1800
port_range=10
port_range_1=1


declare -i SUM=0
for ((i=$1;i<=$node_num;i+=1))
do
	echo "===== 当前正在创建节点名称 : bee_$i ====="

    folder="bee_$i"
	echo "当前正在创建节点所在目录名称: $folder..."

        if [ ! -x "$folder" ]; then
       		 mkdir -p "$folder"
        fi

	cd $folder
	cp ../resource/docker-compose.yml ./

	sed -i "s/clef-1/clef-$i/g" docker-compose.yml
	sed -i "s/bee-1/bee-$i/g" docker-compose.yml

	

    if [ $1 -eq $i ] 
        then 
            port3=$[$port3+$1]
            port1=$[$port1+$1]
	        port2=$[$port2+$1]
    else 
        port1=$[$port1+$port_range_1]
	    port2=$[$port2+$port_range_1]
        port3=$[$port3+$port_range_1]
    fi

	sed -i "s/API_ADDR:-1633/API_ADDR:-$port1/"	docker-compose.yml
	sed -i "s/P2P_ADDR:-1634/P2P_ADDR:-$port2/"	docker-compose.yml
	sed -i "s/0.0.0.0:1635/0.0.0.0:$port3/"	docker-compose.yml

	cp ../resource/.env ./

	docker-compose -f docker-compose.yml --env-file .env up -d

   ## echo "提取当前节点eth地址"
   ## addr="$(docker-compose -f docker-compose.yml --env-file=.env logs bee-$i |  grep 'ethereum' | head -n 1 )"
   ## while [ "$addr" == "" ]
   ## do
   ##     echo "正在提取当前节点eth地址, 5s重试中..."
   ##     sleep 5
   ##     addr="$(docker-compose -f docker-compose.yml --env-file=.env logs bee-$i |  grep 'ethereum' | head -n 1 )"
   ## done
   ## echo "eth地址提取完毕 : $addr, 导入节点统一地址文件 ../addr.log"
   ## echo $addr >> ../addr.log
    echo $port3 >> ../debug_port.log

    echo "===== 当前节点 : bee_$i  创建完毕 ====="
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