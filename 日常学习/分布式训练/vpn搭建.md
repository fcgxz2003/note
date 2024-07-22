参考学习 https://blog.csdn.net/m0_56015193/article/details/134590283


三台机器的openvpn搭建

|     | 映射ip| 映射端口| 内网ip| GPU|
|----------:|----------:|----------:|----------:|----------:|
|1|210.30.97.178| 2222|  192.168.1.170|NVIDIA A100-SXM4-80GB * 1|
|2|210.30.97.179| 2222|  192.168.1.144|NVIDIA A100-SXM4-80GB * 2|
|3|210.30.97.181| 2222|  192.168.2.183|NVIDIA A100-SXM4-80GB * 2|


## VPN搭建

https://github.com/angristan/openvpn-install
![alt text](image.png)
![alt text](image-1.png)
默认端口为1194

查看端口
sudo ss -tupln | grep openvpn
![alt text](image-4.png)

查看server 状态
sudo systemctl status openvpn
![alt text](image-3.png)

检查网络接口，一个新的接口已经为Vpn隧道创建，可以使用iP命令确认这一点
ip add
![alt text](image-5.png)

启动OpenVpn服务，让它在系统启动时自动启动，并检查其状态以确认它已启动并正在运行
sudo systemctl start openvpn 
sudo systemctl enable openvpn 
sudo systemctl status openvpn

## client 端安装
https://community.openvpn.net/openvpn/wiki/OpenvpnSoftwareRepos#InstallingOpenVPN

就简单sudo apt-get install openvpn
然后openvpn --config ~.ovpn文件就行

用 tun0的ip 进行通信

## 踩坑

### 端口映射查看一下option proto 是什么，是tcp 的话需要修改成udp,因为默认openvpn默认配置是udp.


### client 之间不互通，需要在server.conf 文件中添加client-to-client.
把 /etc/openvpn/server.conf 配置内容添加client-to-client
重启openvpn服务
systemctl restart openvpn@server