V2Ray Base Image
=================

![GitHub Workflow Status](https://img.shields.io/github/workflow/status/chinayin-docker/v2ray/Docker%20Image%20CI)
![Docker Image Version (latest semver)](https://img.shields.io/docker/v/chinayin/v2ray?sort=semver)
![Docker Image Size (latest semver)](https://img.shields.io/docker/image-size/chinayin/v2ray?sort=semver)
![Docker Pulls](https://img.shields.io/docker/pulls/chinayin/v2ray)

A platform for building proxies to bypass network restrictions.

Using 
------------

You can use the image directly, e.g.

```bash
docker run --rm -it chinayin/v2ray:bullseye
```

The images are built daily and have the security release enabled, so will contain any security updates released more
than 24 hours ago.

You can also use the images as a base for your own Dockerfile:

```bash
FROM chinayin/debian:bullseye
```

### 客户端安装

文件列表：

- v2ray.exe 运行 V2Ray 的程序文件
- wv2ray.exe 同 v2ray.exe，区别在于wv2ray.exe是后台运行的，不像 v2ray.exe 会有类似于 cmd 控制台的窗口。运行 V2Ray 时从 v2ray.exe 和 wv2ray.exe 中任选一个即可
- config.json V2Ray 的配置文件，后面我们对 V2Ray 进行配置其实就是修改这个文件
- v2ctl.exe V2Ray 的工具，有多种功能，除特殊用途外，一般由 v2ray.exe 来调用，用户不用太关心
- geosite.dat 用于路由的域名文件
- geoip.dat 用于路由的 IP 文件

### 附录

- 时间是否准确

V2Ray 对于时间有比较严格的要求，要求服务器和客户端时间差绝对值不能超过 2 分钟，所以一定要保证时间足够准确。还好 V2Ray 并不要求时区一致。比如说自个儿电脑上的时间是北京时间（东 8 区）2017-07-31 12:08:31，但是 VPS 上的时区是东 9 区，所以 VPS 上的时间应该是2017-07-31 13:06:31 到 2017-07-31 13:10:31 之间才能正常使用 V2Ray。当然，也可以自行改成自己想要的时区。

- 日志文件

依次看 log 的选项：
- loglevel：日志级别，分别有5个，本例中设定的是 warning
    - debug：最详细的日志信息，专用于软件调试
    - info：比较详细的日志信息，可以看到 V2Ray 详细的连接信息
    - warning：警告信息。轻微的问题信息，经我观察 warning 级别的信息大多是网络错误。推荐使用 warning
    - error：错误信息。比较严重的错误信息。当出现 error 时该问题足以影响 V2Ray 的正常运行
    - none：空。不记录任何信息
- access：将访问的记录保存到文件中，这个选项的值是要保存到的文件的路径
- error：将错误的记录保存到文件中，这个选项的值是要保存到的文件的路径
- error、access 字段留空，并且在手动执行 V2Ray 时，V2Ray 会将日志输出在 stdout 即命令行中（terminal、cmd 等），便于排错

配置：
```json5
{
  "log": {
    // 日志级别
    "loglevel": "warning",
    // 这里 linux 系统的路径
    "access": "/var/log/v2ray/access.log",
    // 这是 Windows 系统的路径
    "error": "D:\\v2ray\\error.log"
  }
}
```

- 路由功能

```json5
{
  "log": {
    "loglevel": "warning",
    "access": "D:\\v2ray\\access.log",
    "error": "D:\\v2ray\\error.log"
  },
  "inbounds": [
    {
      "port": 1080,
      "protocol": "socks",
      "settings": {
        "auth": "noauth"  
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom", //原来是 VMess，现在改成 freedom
      "settings": {
      }
    }
  ]
}
```
如果是前面的介绍 VMess，数据包的流向是:

> {浏览器} <--(socks)--> {V2Ray 客户端 inbound <-> V2Ray 客户端 outbound} <--(VMess)-->  {V2Ray 服务器 inbound <-> V2Ray 服务器 outbound} <--(Freedom)--> {目标网站}

但因为现在 V2Ray 客户端的 outbound 设成了 freedom，freedom 就是直连，所以呢修改后数据包流向变成了这样：

> {浏览器} <--(socks)--> {V2Ray 客户端 inbound <-> V2Ray 客户端 outbound} <--(Freedom)--> {目标网站}

V2Ray 客户端从 inbound 接收到数据之后没有经过 VPS 中转，而是直接由 freedom 发出去了，所以效果跟直接访问一个网站是一样的。

再来看下面这个:

```json5
{
  "log":{
    "loglevel": "warning",
    "access": "D:\\v2ray\\access.log",
    "error": "D:\\v2ray\\error.log"
  },
  "inbounds": [
    {
      "port": 1080,
      "protocol": "socks",
      "settings": {
        "auth": "noauth"  
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "blackhole",
      "settings": {
      }
    }
  ]
}
```
这样的配置生效之后，你会发现无论什么网站都无法访问。这是为什么呢？blackhole 是黑洞的意思，在 V2Ray 这里也差不多相当于是一个黑洞，就是说 V2Ray 从 inbound 接收到数据之后发到 outbound，因为 outbound 是 blackhole，来什么吞掉什么，就是不转发到服务器或者目标网站，相当于要访问什么就阻止访问什么。

- 

- 参考资料：

https://toutyrater.github.io
https://github.com/v2fly/fhs-install-v2ray
https://www.v2ray.com/chapter_02/03_routing.html
https://tachyondevel.medium.com/漫谈各种黑科技式-dns-技术在代理环境中的应用-62c50e58cbd0
https://tachyondevel.medium.com/教程-在-windows-上使用-tun2socks-进行全局代理-aa51869dd0d
https://tachyondevel.medium.com/调用-v2ray-提供的-api-接口进行用户增删操作-adf9ff972973
https://github.com/eycorsican/go-tun2socks
https://github.com/eycorsican/Mellow
[简单介绍一下网络连接的封锁与反封锁](https://steemit.com/cn/@v2ray/6knmmb)
