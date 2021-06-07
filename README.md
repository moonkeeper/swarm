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

param1 = 开始节点编号  
param2 = 总共节点数量  
param3 = u2/m2/d2    u2=u2磁盘/m2=m2磁盘/d2=默认路径 针对不同的存储 详情见具体的sh脚本
```

log
```
tail -f /root/deploy/nohup.out
```

get addr

```
cat /root/deploy/addr.log  | head -n 1
```

# intro file directory && proc seq
```
dir name = /root/swarm/configxx
1. deploy_step_part.sh  完整的部署文件
2. deploy_env.sh   基础环境
3. deploy_part.sh  u2磁盘分区 or deploy_part_m2.sh m2磁盘分区
4. deploy_clef.sh  clef节点部署
5. deploy_bee.sh   bee节点部署  可以使用 nohup ./deploy_bee.sh 1 30 & 单独部署bee

以上2-4步都可以根据已经完成的进度单独执行

```

# 查看当前服务器所有节点deubg端口和eth 钱包地址
```
cat /root/deploy/debug_port.log
cat /root/deploy/addr.log
```

# SHELL 脚本 我只是个弟中弟

