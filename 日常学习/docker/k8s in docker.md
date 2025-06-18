# k8s in docker (kind) 研究
参考网址 https://kind.sigs.k8s.io/docs/user/quick-start/#installation
参考blog https://blog.csdn.net/qq_51149892/article/details/146364748

原本计划是在部署好的k8s 上跑d7y，但是需要上传镜像，比较麻烦，如果可以直接改写完代码，然后打包成镜像后，可以直接测试，那开发速度将大大提升。


kind（Kubernetes IN Docker）是一个通过 Docker 容器模拟 Kubernetes 节点，快速创建本地 Kubernetes 集群的工具。它轻量、快速，适合测试 Kubernetes 功能、开发调试或 CI/CD 环境。

## 安装
```
# For AMD64 / x86_64
[ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.29.0/kind-linux-amd64
# For ARM64
[ $(uname -m) = aarch64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.29.0/kind-linux-arm64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
```

## 测试
```
# 默认创建名为 "kind" 的单节点集群（控制平面 + 工作节点）
kind create cluster

# 输出示例：
Creating cluster "kind" ...
 ✓ Ensuring node image (kindest/node:v1.27.3) 🖼
 ✓ Preparing nodes 📦  
 ✓ Writing configuration 📜 
 ✓ Starting control-plane 🕹️ 
 ✓ Installing CNI 🔌 
 ✓ Installing StorageClass 💾 
Set kubectl context to "kind-kind"

```

这里面的nginx 的实例，最好用
```
kubectl port-forward service/nginx 8080:80 --address 0.0.0.0
```
这样可以允许从任何IP地址访问，而不仅限于Localhost


### kubectl 安装
参考网址 https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/

```
   curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

```

## d7y kind 的部署
参考网址 https://d7y.io/docs/next/getting-started/quick-start/kubernetes/




