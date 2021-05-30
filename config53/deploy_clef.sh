echo "================ 2. 构建节点目录和配置文件信息 ================"
echo "==============  部署 clef 节点  ================"

mkdir -p clef
cp resource/clef_config.yml clef/
cp resource/.env clef/
cd clef
docker-compose -f clef_config.yml --env-file .env up -d
cd ../
echo "睡眠5s 等待clef 启动成功......"