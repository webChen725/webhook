#! /bin/bash
WORK_PATH='/usr/project/developmentTest'
cd $WORK_PATH
echo "开始清除老代码"
git reset --hard origin/master
git clean -f
echo "开始拉取最新代码"
git pull origin master
echo "开始执行构建"
docker build -t developmentTest:1.0 .
echo "停止旧容器并删除"
docker stop developmentTest-container
docker rm developmentTest-container
echo "启动新容器"
docker container run -p 3000:3000 --name developmentTest-container -d developmentTest:1.0
