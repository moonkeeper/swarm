# swarm
for deploy swarm/eth cluster by docker-compose

# 部署deploy脚本
scp git_clone_start.sh root@xxxx.xxxx.xxx.xx:/root/git_clone_start.sh
chmod a+x git_clone_start.sh
./git_clone_start.sh bee_number

# 查看当前服务器所有节点地址
cat /root/deploy/addr.log

# 查看当前服务器所有节点deubg端口
cat /root/deploy/debug_port.log
