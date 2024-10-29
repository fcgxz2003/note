FROM nvidia/cuda:12.2.2-cudnn8-runtime-ubuntu22.04
LABEL description="Mininet(运行需要--privileged启动参数，设置资源限制需要--net=host参数),ryu,Miniconda,ssh环境"
MAINTAINER hangvane <hangvane1@gmail.com>
ARG proxy
ENV SSH_PORT 22
ENV VM_NUMBER 1
ENV PRIVILEGED 1
ENV PORT_MAPPING 0
ENV NET_MODE bridge
ENV PATH_MAPPING 0
ENV HOST_PATH /mnt/home/docker-common-dir
ENV CNTR_PATH /home/common-dir
# 支持中文
RUN echo "export LANG=C.UTF-8" >>/etc/profile \
# 删除nvidia的源
# && rm /etc/apt/sources.list.d/cuda.list \
# && rm /etc/apt/sources.list.d/nvidia-ml.list \
# 更新apt源
&& apt-get update \
# 安装必要软件
&& apt-get install -y --no-install-recommends \
  apt-utils \
  vim \
  openssh-server \
  net-tools \
  iputils-ping \
  wget \
  curl \
  sudo \
  git \
  iptables \
  bzip2 \
  command-not-found \
  python3 \
  python3-pip \
  python-setuptools \
  ca-certificates \
  p7zip-full \
  zip \
# 下载安装Miniconda
&& wget -q --no-check-certificate https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
&& bash Miniconda3-latest-Linux-x86_64.sh -b \
# 删除安装文件
&& rm Miniconda3-latest-Linux-x86_64.sh \
# 可以使用conda命令
&& ln -s /root/miniconda3/etc/profile.d/conda.sh /etc/profile.d/conda.sh \
# 创建conda py310环境
&& /root/miniconda3/bin/conda create -q -npy310 python=3.10 -y \
# pip更新
&& /root/miniconda3/envs/py310/bin/pip install pip -U \
# 设置允许root登录ssh
&& sed -i '/^#*PermitRootLogin/cPermitRootLogin yes' /etc/ssh/sshd_config \
&& echo "PasswordAuthentication no" >>/etc/ssh/sshd_config \
# 修改SSH端口，设为启动项，注意docker容器里一般的Ubuntu设置启动项的方式不会生效
&& echo "#!/bin/bash\n\
sed -i \"s/^#*Port 22/Port \$SSH_PORT/g\" /etc/ssh/sshd_config\n\
service ssh start\n\
/bin/bash" >/home/startup.sh \
# 添加运行权限
&& chmod 777 /home/startup.sh \
# 将docker env添加至ssh环境变量
&& echo "for item in \`cat /proc/1/environ |tr '\\\0' '\\\n'\`\n\
do\n\
  export \$item\n\
done" >>/etc/profile \
# 添加欢迎界面提示
&& CONDA_VERSION=`/root/miniconda3/condabin/conda -V` \
&& CONDA_VERSION=${CONDA_VERSION#* } \
&& echo "#!/bin/bash\n\
export \$(cat /proc/1/environ |tr '\\\0' '\\\n' | xargs)\n\
if [[ \$PRIVILEGED = '0' ]]; then\n\
  PRIVILEGED_STR='是'\n\
else\n\
  PRIVILEGED_STR='否'\n\
fi\n\
printf '\\\n'\n\
printf '\\\033[0;34m'\n\
printf ' 欢迎使用Cardiff GPU服务器01\\\n'\n\
printf ' 本机编号见机器名\\\n'\n\
printf ' ssh默认仅支持密钥登录\\\n'\n\
printf '\\\n'\n\
printf ' CUDA:\\\t\\\tv$CUDA_VERSION\\\n'\n\
printf ' CUDNN:\\\t\\\tv$NV_CUDNN_VERSION\\\n'\n\
printf ' Conda:\\\t\\\tMiniconda v$CONDA_VERSION 使用 \`conda activate py310\` 来激活conda环境\\\n'\n\
printf '\\\n'\n\
printf ' 端口映射:\\\t本机\\\t\\\t宿主机\\\n'\n\
if [[ \$NET_MODE = 'bridge' ]]; then\n\
  if [[ \$PORT_MAPPING = '0' ]]; then\n\
    printf \"\\\t\\\t4000\\\t->\\\t$[6100+5*VM_NUMBER]\\\n\"\n\
    printf \"\\\t\\\t4001\\\t->\\\t$[6101+5*VM_NUMBER]\\\n\"\n\
    printf \"\\\t\\\t4002\\\t->\\\t$[6102+5*VM_NUMBER]\\\n\"\n\
    printf \"\\\t\\\t4003\\\t->\\\t$[6103+5*VM_NUMBER]\\\n\"\n\
    printf \"\\\t\\\t4004\\\t->\\\t$[6104+5*VM_NUMBER]\\\n\"\n\
  fi\n\
fi\n\
printf \" ssh端口:\\\t\$SSH_PORT\\\t->\\\t$[6000+VM_NUMBER]\\\n\"\n\
if [[ \$PATH_MAPPING = '0' ]]; then\n\
  printf \" 目录共享:\\\t本机:\$CNTR_PATH  ->  宿主机:\$HOST_PATH\\\n\"\n\
fi\n\
printf \" 特权模式:\\\t\$PRIVILEGED_STR\n\"\n\
printf \" 网络模式:\\\t\$NET_MODE\n\"\n\
printf '\\\033[0m'\n\
printf '\\\n'\n\
" >>/etc/update-motd.d/11-welcome-text \
&& chmod 777 /etc/update-motd.d/11-welcome-text \
&& rm /etc/update-motd.d/10-help-text \
# 清理
&& rm -rf /var/lib/apt/lists/* /tmp/*
# 设置启动脚本
ENTRYPOINT /home/startup.sh
