改变容器部署的节点位置。

kubesphere中修改持久卷声明yaml文件中selected-node 并且删除、重新创建Pod,并不能改变位置。

首先要把Pod停下来，然后需要用kubectl 将pvc的绑定关系删去
```Shell
[root_dlutcardiff@m1 ~]$ kubectl delete pvc -n d7y storage-dragonf-ulg1d8-dragonfly-peer-3
persistentvolumeclaim "storage-dragonf-ulg1d8-dragonfly-peer-3" deleted
```

最后修改peer 的yaml文件
```yaml
spec:
    template：
        spec:
            nodeSelector:
            kubernetes.io/hostname: m2
```