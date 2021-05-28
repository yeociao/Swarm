#!/bin/bash

function removeDocker () {
   sudo yum remove docker \
            docker-client \
            docker-client-latest \
            docker-common \
            docker-latest \
            docker-latest-logrotate \
            docker-logrotate \
            docker-selinux \
            docker-engine-selinux \ 
            docker-engine
}
echo "卸载Docker旧版本"
removeDocker
echo "卸载Docker旧版本成功"

function installYum () {
    sudo yum install -y yum-utils \
          device-mapper-persistent-data \
          lvm2
}
echo "开始安装yum..."
installYum
echo "安装yum成功"

function yumConfig () {
    sudo yum-config-manager \
    --add-repo \
    https://mirrors.ustc.edu.cn/docker-ce/linux/centos/docker-ce.repo
}

echo "开始配置国内镜像源..."
yumConfig
echo "配置国内镜像源成功"

function installDocker () {
    sudo yum makecache fast 
    sudo yum install docker-ce -y
}

echo "开始安装Docker..."
installDocker
echo "Docker安装成功"

function startDocker () {
   sudo systemctl enable docker
   sudo systemctl start docker
}

echo "启动Docker..."
startDocker
echo "Docker启动成功"

function installDockerCompose () {
    sudo yum install curl -y
    sudo curl -L https://hub.fastgit.org/docker/compose/releases/download/1.17.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
}

echo "开始安装Docker-Compose..."
installDockerCompose
echo "Docker-Compose安装成功"
echo "congratulations！！！你的人品太好了，Docker安装配置成功，请开始你的表演吧！！！"
