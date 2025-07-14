结合docker/docker registry搭建部分
现在已经搭建好了，然后开始配置


ImagesPullSecrets 可以控制helm-charts 中的每个组件拉取的地址。


```BASH
[root_dlutcardiff@m1 d7y]$ kubectl create secret docker-registry private-registry-secret \
>   --docker-server=210.30.97.59:5000 \
>   --docker-username=admin \
>   --docker-password=admin \
>   -n dragonfly-system
secret/private-registry-secret created
```

然后修改 Helm Chart 的 values.yaml，设置全局的 imageRegistry 和 imagePullSecrets：

注：已经不用把账号密码写一遍了
```YAML
global:
  imageRegistry: "210.30.97.59:5000"
  imagePullSecrets:
    - name: private-registry-secret
  nodeSelector: {}
  storageClass: ""
```