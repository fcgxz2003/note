# Nvidia-Docker 安装Ollma
``
curl -fsSL https://ollama.com/install.sh | sh
``

WARNING: Unable to detect NVIDIA/AMD GPU. Install lspci or lshw to automatically detect and install GPU dependencies.

# 安装lspci
``
sudo apt install pciutils
``

# 安装lshw
``
sudo apt install lshw
``

The Ollama API is now available at 127.0.0.1:11434.
这里需要做个端口映射，把11434 映射到别的端口
