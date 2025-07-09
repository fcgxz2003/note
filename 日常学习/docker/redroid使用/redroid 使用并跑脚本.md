星铁每天上线麻烦，本来想着跑个脚本，然后每天帮忙日常+模拟宇宙，但是发现太麻烦了，毕竟又要模拟器又要adb 又要alsa之类的。尽管docker 给了很大帮助，但还是没那么简单

本质上就是用redroid 镜像来跑星铁，然后adb 来connect 容器内容，然后服务器上装脚本，映射端口访问这样。


redroid deploy in debain
https://github.com/remote-android/redroid-doc/blob/master/deploy/debian.md

docker-compse.yaml 脚本，用来跑redroid

```YAML
services:
  redroid:
    image: redroid/redroid:12.0.0-240527
    container_name: redroid
    ports:
      - 5555:5555
    network_mode: bridge
    privileged: true
    volumes:
      - /dev/binder1:/dev/binder
      - /dev/binder2:/dev/hwbinder
      - /dev/binder3:/dev/vndbinder
      - ./data:/data
    command:
      - androidboot.redroid_net_ndns=1
      - androidboot.redroid_net_dns1=202.118.66.6
      - androidboot.redroid_gpu_mode=guest
      - androidboot.use_memfd=1
      - androidboot.redroid_fps=30
```

然后在有UI 的界面上，用adb 来进行connect
```
adb connect 210.xx.xx.xx:5555
scrcpy --audio-codec=aac --video-bit-rate=24M
```

然后发现
https://github.com/remote-android/redroid-doc/issues/742

BTW, nvidia-container-toolkit won't work. And Nvidia GPU drivers for Linux is not compatible with Android.

创业为半而中道崩殂
