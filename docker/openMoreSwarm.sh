#!/bin/bash

# 需要运行的Swarm容器数量，可根据自己电脑配置自行修改此值
let count=10


function createBeeNodeDir () {
    sudo mkdir /usr/local/docker
    for((i=0;i<$count;i++)); do
        sudo mkdir /usr/local/docker/bee-node$i
    done
}

echo "批量创建Bee节点目录"
createBeeNodeDir
echo "创建Bee节点目录成功，路径为/usr/local/docker"

function createDockerComposeDoYml () {
    for((i=0;i<$count;i++)); do
    let baseCount=3
    let basePort=$(($(($(($baseCount+$i))+($i)))+$i))
    sudo touch /usr/local/docker/bee-node$i/docker-compose.yml
    cat <<EOF > /usr/local/docker/bee-node$i/docker-compose.yml
version: "3"
services:
  clef-$i:
    image: ethersphere/clef:0.4.12
    restart: unless-stopped
    environment:
      - CLEF_CHAINID
    volumes:
      - clef-$i:/app/data
    command: full
  bee-$i:
    image: ethersphere/bee:beta
    restart: unless-stopped
    environment:
      - BEE_API_ADDR
      - BEE_BOOTNODE
      - BEE_BOOTNODE_MODE
      - BEE_CLEF_SIGNER_ENABLE
      - BEE_CLEF_SIGNER_ENDPOINT=http://clef-$i:8550
      - BEE_CONFIG
      - BEE_CORS_ALLOWED_ORIGINS
      - BEE_DATA_DIR
      - BEE_DB_CAPACITY
      - BEE_DB_OPEN_FILES_LIMIT
      - BEE_DB_BLOCK_CACHE_CAPACITY
      - BEE_DB_WRITE_BUFFER_SIZE
      - BEE_DB_DISABLE_SEEKS_COMPACTION
      - BEE_DEBUG_API_ADDR
      - BEE_DEBUG_API_ENABLE
      - BEE_GATEWAY_MODE
      - BEE_GLOBAL_PINNING_ENABLE
      - BEE_NAT_ADDR
      - BEE_NETWORK_ID
      - BEE_P2P_ADDR
      - BEE_P2P_QUIC_ENABLE
      - BEE_P2P_WS_ENABLE
      - BEE_PASSWORD
      - BEE_PASSWORD_FILE
      - BEE_PAYMENT_EARLY
      - BEE_PAYMENT_THRESHOLD
      - BEE_PAYMENT_TOLERANCE
      - BEE_RESOLVER_OPTIONS
      - BEE_STANDALONE
      - BEE_SWAP_ENABLE
      - BEE_SWAP_ENDPOINT
      - BEE_SWAP_FACTORY_ADDRESS
      - BEE_SWAP_INITIAL_DEPOSIT
      - BEE_TRACING_ENABLE
      - BEE_TRACING_ENDPOINT
      - BEE_TRACING_SERVICE_NAME
      - BEE_VERBOSITY
      - BEE_WELCOME_MESSAGE
    ports:
      - "163$basePort:1633"
      - "163$(($basePort+1)):1634"
      - "163$(($basePort+2)):1635"
    volumes:
      - bee-$i:/home/bee/.bee
    command: start
    depends_on:
      - clef-$i
volumes:
  clef-$i:
  bee-$i:
EOF
done
}

echo "创建docker-compose.yml文件"
createDockerComposeDoYml
echo "docker-compose.yml创建成功"

function createDockerComposeDoEnv () {
    sudo touch /usr/local/docker/bee-node1/.env
     for((i=0;i<$count;i++)); do
    cat <<EOF >/usr/local/docker/bee-node$i/.env
# Copy this file to .env, then update it with your own settings
### CLEF
## chain id to use for signing (1=mainnet, 3=ropsten, 4=rinkeby, 5=goerli) (default: 12345)
CLEF_CHAINID=5
### BEE
## HTTP API listen address (default :1633)
# BEE_API_ADDR=:1633
## chain block time (default 15)
# BEE_BLOCK_TIME=15
## initial nodes to connect to (default [/dnsaddr/bootnode.ethswarm.org])
# BEE_BOOTNODE=[/dnsaddr/bootnode.ethswarm.org]
## cause the node to always accept incoming connections
# BEE_BOOTNODE_MODE=false
## enable clef signer
BEE_CLEF_SIGNER_ENABLE=true
## clef signer endpoint
BEE_CLEF_SIGNER_ENDPOINT=http://clef-$i:8550
## config file (default is /home/<user>/.bee.yaml)
# BEE_CONFIG=/home/bee/.bee.yaml
## origins with CORS headers enabled
# BEE_CORS_ALLOWED_ORIGINS=[]
## data directory (default /home/<user>/.bee)
# BEE_DATA_DIR=/home/bee/.bee
## db capacity in chunks, multiply by 4096 to get approximate capacity in bytes
# BEE_DB_CAPACITY=5000000
## number of open files allowed by database
BEE_DB_OPEN_FILES_LIMIT=2000
## size of block cache of the database in bytes
# BEE_DB_BLOCK_CACHE_CAPACITY=33554432
## size of the database write buffer in bytes
# BEE_DB_WRITE_BUFFER_SIZE=33554432
## disables db compactions triggered by seeks
# BEE_DB_DISABLE_SEEKS_COMPACTION=false
## debug HTTP API listen address (default :1635)
# BEE_DEBUG_API_ADDR=:1635
## enable debug HTTP API
BEE_DEBUG_API_ENABLE=true
## disable a set of sensitive features in the api
# BEE_GATEWAY_MODE=false
## enable global pinning
# BEE_GLOBAL_PINNING_ENABLE=false
## cause the node to start in full mode
BEE_FULL_NODE=true 
## NAT exposed address
# BEE_NAT_ADDR=
## ID of the Swarm network (default 1)
# BEE_NETWORK_ID=1
## P2P listen address (default :1634)
# BEE_P2P_ADDR=:1634
## enable P2P QUIC protocol
# BEE_P2P_QUIC_ENABLE=false
## enable P2P WebSocket transport
# BEE_P2P_WS_ENABLE=false
## password for decrypting keys
 BEE_PASSWORD=my-password
## path to a file that contains password for decrypting keys
# BEE_PASSWORD_FILE=
## amount in BZZ below the peers payment threshold when we initiate settlement (default 10000)
# BEE_PAYMENT_EARLY=10000
## threshold in BZZ where you expect to get paid from your peers (default 100000)
# BEE_PAYMENT_THRESHOLD=100000
## excess debt above payment threshold in BZZ where you disconnect from your peer (default 10000)
# BEE_PAYMENT_TOLERANCE=10000
## postage stamp contract address
# BEE_POSTAGE_STAMP_ADDRESS=
## ENS compatible API endpoint for a TLD and with contract address, can be repeated, format [tld:][contract-addr@]url
# BEE_RESOLVER_OPTIONS=[]
## whether we want the node to start with no listen addresses for p2p
# BEE_STANDALONE=false
## enable swap (default true)
# BEE_SWAP_ENABLE=true
## swap ethereum blockchain endpoint (default http://localhost:8545)
 BEE_SWAP_ENDPOINT=https://rpc.slock.it/goerli
## swap factory address
# BEE_SWAP_FACTORY_ADDRESS=
## legacy swap factory addresses
# BEE_SWAP_LEGACY_FACTORY_ADDRESSES=
## initial deposit if deploying a new chequebook (default 100000000)
# BEE_SWAP_INITIAL_DEPOSIT=100000000
## gas price in wei to use for deployment and funding (default "")
# BEE_SWAP_DEPLOYMENT_GAS_PRICE=
## enable tracing
# BEE_TRACING_ENABLE=false
## endpoint to send tracing data (default 127.0.0.1:6831)
# BEE_TRACING_ENDPOINT=127.0.0.1:6831
## service name identifier for tracing (default bee)
# BEE_TRACING_SERVICE_NAME=bee
## proof-of-identity transaction hash
# BEE_TRANSACTION=
## log verbosity level 0=silent, 1=error, 2=warn, 3=info, 4=debug, 5=trace (default info)
# BEE_VERBOSITY=info
## send a welcome message string during handshakes
# BEE_WELCOME_MESSAGE=
EOF
done
}

echo "创建.env文件"
createDockerComposeDoEnv
echo "创建.env文件成功"
