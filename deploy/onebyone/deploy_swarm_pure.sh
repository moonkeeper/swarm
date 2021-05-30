#!/bin/bash -e

echo "================ 构建节点目录和配置文件信息 ================"

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