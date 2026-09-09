# 使用官方 Node 镜像（Debian 底包自带 glibc，适合编译 native 扩展）
FROM node:22-bookworm-slim AS builder

# 安装编译 C 原生扩展所需的依赖
RUN apt-get update && apt-get install -y build-essential python3 && rm -rf /var/lib/apt/lists/*
RUN npm install -g pnpm

WORKDIR /app

# 优先拷贝依赖配置，利用 Docker 缓存
COPY package.json pnpm-lock.yaml* ./
RUN pnpm install

# 拷贝其余源码并执行 build
COPY . .
RUN pnpm run build

# 暴露服务端口（根据实际端口修改，一般为 3000 或 8080）
EXPOSE 3000

# 启动命令
CMD ["pnpm", "start"]
