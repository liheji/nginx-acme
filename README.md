# Nginx and Acme.sh

-   基于 [nginxinc/docker-nginx](https://github.com/nginxinc/docker-nginx) 官方docker 修改的，集成  [acmesh-official/acme.sh](https://github.com/acmesh-official/acme.sh),
-   将 acme.sh 直接打包进 nginx 官方 docker 镜像中，**实现启动容器自动申请泛域名证书**
-   需要使用该证书的时候，直接使用 `/cert/[域名].crt`和`/cert/[域名].key`即可。

>   注意：由于申请的是泛域名证书，因此你必须为域名拥有者
> 
>   注意：**重新创建容器**会重新申请泛域名证书

### 构建镜像

```sh
docker build -t nginx-acme .
```

### 拉取镜像

```sh
docker pull yilee01/nginx-acme
```

# 运行程序

+ `/cert`：申请的证书地址
+ `/etc/nginx/conf.d`：nginx配置文件地址
+ `/etc/nginx/nginx.conf`：nginx全局配置

> 注意：使用需要传递下述命令中的环境变量给docker，供acme.sh使用
>
> 注意：默认使用 dns_cf（Cloudflare），其他域名参考[DNS  API](https://github.com/acmesh-official/acme.sh/wiki/dnsapi)

### 命令

```bash
docker run -d \
  --name nginx \
  -v ./cert:/cert \
  -v ./conf.d:/etc/nginx/conf.d \
  -v ./nginx.conf:/etc/nginx/nginx.conf \
  -e CF_Token=[TOKEN] \
  -e CF_Account_ID=[账号] \
  -e DNS=dns_cf \
  -e DOMAIN=[域名] \
  -e EMAIL=[邮箱] \
  yilee01/nginx-acme:latest
```

### docker-compose

```yml
version: '3.3'
services:
  nginx:
    container_name: nginx
    image: yilee01/nginx-acme:latest
    restart: always
    network_mode: "host"
    volumes:
      - ./cert:/cert
      - ./conf.d:/etc/nginx/conf.d
      - ./nginx.conf:/etc/nginx/nginx.conf
    environment:
      - CF_Token=[TOKEN]
      - CF_Account_ID=[账号]
      - DNS=dns_cf
      - DOMAIN=[域名]
      - EMAIL=[邮箱]
```

