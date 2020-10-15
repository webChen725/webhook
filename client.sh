#! /bin/bash
WORK_PATH='/usr/project/clientTest'
cd $WORK_PATH
echo "开始清除老代码"
git reset --hard origin/master
git clean -f
echo "开始拉取最新代码"
git pull origin master
echo "开始编译代码"
rm -rf node_modules
npm install
npm run build
echo "开始执行构建"
docker build -t client-test:1.0 .
echo "停止旧容器并删除"
docker stop clientTest-container
docker rm clientTest-container
echo "启动新容器"
docker container run -p 80:80 --name clientTest-container -d client-test:1.0
