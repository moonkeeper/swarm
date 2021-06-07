# swarm
for deploy swarm/eth cluster by docker-compose


# dependency && requirement
1. centos7+
2. git 

```
yum install -y git
git --version
```

# install && deploy

clone shell repo
```
cd /root
git clone https://github.com/moonkeeper/swarm.git  

```

exec
```
nohup ./swarm/config53/boot.sh  param1 param2 param3 &
```
param1 = 开始节点编号  
param2 = 总共节点数量  
param3 = u2/m2/d2    u2=u2磁盘/m2=m2磁盘/d2=默认路径

log
```
tail -f /root/deploy/nohup.out
```

get addr

```
cat /root/deploy/addr.log  | head -n 1
```

# intro file directory 
```
dir name = /root/swarm/config53
deploy.sh  完整的部署文件
deploy_part.sh  分区
deploy_env.sh   基础环境
deploy_bee.sh   bee节点部署
deploy_clef.sh  clef节点部署
```

# 查看当前服务器所有节点deubg端口
cat /root/deploy/debug_port.log


