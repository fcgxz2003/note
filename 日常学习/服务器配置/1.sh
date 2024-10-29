#!/bin/bash
IMAGE_NAME="cuda-base:1.0"
SSH_KEY_PATH="./ssh_keys"

currNumVM=`docker ps -a|grep -oP "(?<=vm_)\d+"|sort -rn|head -n1`
if [ ! -n "$currNumVM" ]; then
  currNumVM=0
fi

imageName=$IMAGE_NAME
#read -p $'请输入docker镜像名称:\n' -e -i "$IMAGE_NAME" imageName
#until [[ "$imageName" =~ ^[0-9a-zA-Z_\-:.]+$ ]]; do
#  echo "镜像名非法."
#  read -p $'请输入docker镜像名:\n' -e -i "$IMAGE_NAME" imageName
#done

read -p $'请输入容器名(docker标识符):\n' -e -i "vm_$[currNumVM+1]" cntrName
until [[ "$cntrName" =~ ^[0-9a-zA-Z_\-]+$ ]]; do
  echo "容器名必须由数字, 字母或下划线组成."
  read -p $'请输入容器名:\n' -e -i "vm_$[currNumVM+1]" cntrName
done

read -p $'请输入主机名(linux机器名):\n' -e -i "Cardiff_VM_$[currNumVM+1]" hostName
until [[ "$hostName" =~ ^[0-9a-zA-Z_\-]+$ ]]; do
  echo "主机名必须由数字, 字母或下划线组成."
  read -p $'请输入主机名:\n' -e -i "Cardiff_VM_$[currNumVM+1]" hostName
done

read -p $'是否使用host网络模式(默认使用bridge模式)? [y/N]:\n' yesNo
until [[ "$yesNo" =~ ^[yYnN]*$ ]]; do
  echo "$yesNo: 无效输入."
  read -p $'是否使用host网络模式(默认使用bridge模式)? [y/N]:\n' yesNo
done
if [[ "$yesNo" =~ ^[yY]$ ]]; then
  net="host"
else
  net="bridge"
  read -p $'是否映射端口? [Y/n]:\n' yesNo
  until [[ "$yesNo" =~ ^[yYnN]*$ ]]; do
    echo "$yesNo: 无效输入."
    read -p $'是否映射端口? [Y/n]:\n' yesNo
  done
  if [[ "$yesNo" =~ ^[nN]$ ]]; then
    portMapping=1
  else
    portMapping=0
  fi
fi

read -p $'是否以特权模式privileged启动? [y/N]:\n' yesNo
until [[ "$yesNo" =~ ^[yYnN]*$ ]]; do
  echo "$yesNo: 无效输入."
  read -p $'是否以特权模式privileged启动? [y/N]:\n' yesNo
done
if [[ "$yesNo" =~ ^[yY]$ ]]; then
  privileged=0
else
  privileged=1
fi

read -p $'是否自启动? [Y/n]:\n' yesNo
until [[ "$yesNo" =~ ^[yYnN]*$ ]]; do
  echo "$yesNo: 无效输入."
  read -p $'是否自启动? [Y/n]:\n' yesNo
done
if [[ "$yesNo" =~ ^[nN]$ ]]; then
  restart=1
else
  restart=0
fi

read -p $'是否进行目录映射? [Y/n]:\n' yesNo
until [[ "$yesNo" =~ ^[yYnN]*$ ]]; do
  echo "$yesNo: 无效输入."
  read -p $'是否进行目录映射? [Y/n]:\n' yesNo
done
if [[ "$yesNo" =~ ^[nN]$ ]]; then
  pathMapping=1
else
  pathMapping=0
  read -p $'请输入宿主机目录的绝对路径:\n' -e -i "/mnt/home/docker-common-dir" hostPath
  until [[ "$hostPath" =~ ^/([0-9a-zA-Z_\-]+/?)+$ ]]; do
    echo "请输入合法路径."
    read -p $'请输入宿主机目录的绝对路径:\n' -e -i "/mnt/home/docker-common-dir" hostPath
  done
  read -p $'请输入容器目录的绝对路径:\n' -e -i "/home/common-dir" cntrPath
  until [[ "$cntrPath" =~ ^/([0-9a-zA-Z_\-]+/?)+$ ]]; do
    echo "请输入合法路径."
    read -p $'请输入容器目录的绝对路径:\n' -e -i "/home/common-dir" cntrPath
  done
fi

command="docker run -dit --gpus=all"

command="$command --name=$cntrName"

command="$command -h=$hostName"

if [[ "$privileged" = "0" ]]; then
  command="$command --privileged"
fi

if [[ "$restart" = "0" ]]; then
  command="$command --restart=always"
fi

if [[ "$net" = "bridge" ]]; then
  command="$command -p$[6000+currNumVM+1]:22"
  if [[ "$portMapping" = "0" ]]; then
    command="$command -p$[6100+5*(currNumVM+1)]:4000"
    command="$command -p$[6101+5*(currNumVM+1)]:4001"
    command="$command -p$[6102+5*(currNumVM+1)]:4002"
    command="$command -p$[6103+5*(currNumVM+1)]:4003"
    command="$command -p$[6104+5*(currNumVM+1)]:4004"
  fi
else
  command="$command --net=host"
  command="$command -e SSH_PORT=$[6000+currNumVM+1]"
fi
command="$command -e NET_MODE=$net"
command="$command -e PORT_MAPPING=$portMapping"
command="$command -e VM_NUMBER=$[currNumVM+1]"
command="$command -e PRIVILEGED=$privileged"
command="$command -e PATH_MAPPING=$pathMapping"

if [[ "$pathMapping" = "0" ]]; then
  command="$command -v $hostPath:$cntrPath"
  command="$command -e HOST_PATH=$hostPath"
  command="$command -e CNTR_PATH=$cntrPath"
fi

command="$command $imageName"
read -p $'即将执行的指令, 回车以执行:\n' -e -i "$command" command
echo `$command`

echo "为容器添加ssh密钥..."
docker exec $cntrName mkdir /root/.ssh
docker exec $cntrName bash -c 'ssh-keygen -f ~/.ssh/id_rsa -N ""'
docker exec $cntrName bash -c "cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys"
docker exec $cntrName chmod 600 /root/.ssh/authorized_keys
docker exec $cntrName chmod 700 /root/.ssh
docker cp $cntrName:/root/.ssh/id_rsa $SSH_KEY_PATH/$cntrName
docker cp $cntrName:/root/.ssh/id_rsa.pub $SSH_KEY_PATH/$cntrName.pub
echo "密钥已保存于宿主机$SSH_KEY_PATH/$cntrName"