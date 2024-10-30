# GPU服务器的性能实时监控（由nvidia_gpu_exploter+prometheus+grafana实现）

参考blog 
https://juejin.cn/post/7345423755948720182

## 安装 nvidia_gpu_exploter
```
VERSION=1.1.0
wget https://github.com/utkuozdemir/nvidia_gpu_exporter/releases/download/v${VERSION}/nvidia_gpu_exporter_${VERSION}_linux_x86_64.tar.gz
tar -xvzf nvidia_gpu_exporter_${VERSION}_linux_x86_64.tar.gz
mv nvidia_gpu_exporter /usr/bin
nvidia_gpu_exporter --help
```

目前最新版本为1.2.1
https://github.com/utkuozdemir/nvidia_gpu_exporter/releases/tag/v1.2.1

linux 版本为
Linux am-18c00922bb6b.intern 6.1.0-26-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.112-1 (2024-09-30) x86_64 GNU/Linux

```
dpkg -i nvidia-gpu-exporter_1.2.1_linux_amd64.deb 
systemctl status nvidia_gpu_exporter.service
```

http://210.30.97.60:9835/
可以看到内容，说明安装成功


## 安装 prometheus
简化点安装
```
sudo  apt install prometheus
```

在/etc/prometheus目录，修改prometheus.yml，设置prometheus的数据源，设置为nvidia_gpu_exploter(localhost:9835)


然后开启prometheus服务
```
sudo systemctl start prometheus.service
```

http://210.30.97.60:9090/
可访问prometheus

## 安装 grafana
参考
https://grafana.com/docs/grafana/latest/setup-grafana/installation/debian/

启用服务
```
sudo systemctl start grafana-server.service
```
http://210.30.97.60:3000/
可访问grafana 
初始用户名密码都是admin

