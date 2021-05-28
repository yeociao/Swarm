# Deploy swarm with docker multi-node
#脚本适用于redhat（centos）系列的linux，不适用于ubuntu系列。

step1、
自动化安装docker+docker-compose的脚本

用法：复制step1.sh脚本到windows下保存为installDocker.sh格式的文件，上传到centos7的任意目录，执行命令等待安装成功：

sh installDokcer.sh

step2、
自动部署并安装swarm挖矿程序的脚本（centos7++）

如果你想在一台电脑上部署多个节点请使用step2.sh脚本

用法：复制step2.sh脚本到windows系统下保存为openMoreSwarm.sh格式的文件，上传到centos7的任意目录，执行命令：

sh openMoreSwarm.sh

等待部署成功。脚本默认未自启动脚本，请自行到每个docker-compose.yml文件夹下执行：

docker-compose up -d


###特别说明：你可以先在windows上修改好上面的.env文件配置，再上传到centos上执行脚本命令，可能需要修改的地方：

这里后面的节点交换地址（需要到 infura上注册地址：官网：https://infura.io）：

BEE_SWAP_ENDPOINT=https://rpc.slock.it/goerli

你的密码：

BEE_PASSWORD=my-password

docker-compose.yml会部署在
/usr/local/docker/bee-node/ 目录，进到此目录下可进行相关操作。



step3、
停用容器：
cd /usr/local/docker/bee-node1
docker-compose down

启用容器：
cd /usr/local/docker/bee-node1
docker-compose up -d

查询以太坊地址（查询bee运行日志）第一次运行接水：
cd /usr/local/docker/bee-node1
docker-compose logs -f bee-1

查询密钥地址
cd /var/lib/docker/volumes/swarm2_clef-2/_data/data

