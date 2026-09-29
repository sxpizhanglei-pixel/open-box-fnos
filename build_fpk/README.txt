Open-Box fnOS Package
====================

基于 sing-box 内核 + Web 控制台 (Yacd-meta UI) 的一体化代理面板。

安装后:
- 容器名: open-box
- 控制台: http://<nas-ip>:9090
- 代理端口: 2080 (mixed)
- 配置目录: /vol1/1000/docker/open-box/config
- UI 目录: /vol1/1000/docker/open-box/ui

修改配置后: 在 fnOS 里「重启」该应用,或手动
  docker restart open-box
