本地搭一个docker registry,方便上传下载镜像，同时测试一下私有镜像的d7y 的相关问题
问题来源：
https://cloud-native.slack.com/archives/C038X8KH1QT/p1747600751800069

问题：
Are there any options for authenticating dfdaemon etc against private registries (Google Artifact Registry) without dropping to containerd file snippets (with json/b64 encoded credentials)?  Can we rely completely on imagepullsecrets (will it use those)?

参考blog
https://cloud.tencent.com/developer/article/1518456

# 部署 docker-registry
```BASH
# 第一步：删除先前创建的无认证的仓库容器
docker rm -f docker-registry
# 第二步：创建存放认证用户名和密码的文件：
mkdir ~/xz/docker-registry/auth -p
# 第三步：创建密码验证文件。注意将USERNAME和PASSWORD替换为设置的用户名和密码
docker run --rm \
  --entrypoint htpasswd \
  httpd:2 \
  -Bbn USERNAME PASSWORD \
  > ~/xz/docker-registry/auth/htpasswd
# 这里用admin admin吧
# 第四步：重新启动仓库镜像
docker run -d --name my-registry \
  -p 5000:5000 \
  -v ~/xz/docker-registry/auth:/auth:ro \
  -v ~/xz/docker-registry/data:/var/lib/registry \
  -e REGISTRY_AUTH=htpasswd \
  -e REGISTRY_AUTH_HTPASSWD_REALM="Registry Realm" \
  -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
  registry:2
```

成功

# 尝试登录
## 登录
```
docker login localhost:5000 -u admin -p admin
WARNING! Using --password via the CLI is insecure. Use --password-stdin.
WARNING! Your password will be stored unencrypted in /root/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credential-stores

Login Succeeded
```

## 拉一个基础镜像，打标签并推到私有仓库
```
docker pull busybox:latest
docker tag busybox:latest localhost:5000/busybox-test:latest
docker push localhost:5000/busybox-test:latest
```

# web 访问
```
http://210.30.97.59:5000/v2/_catalog
```
输入账号密码即可