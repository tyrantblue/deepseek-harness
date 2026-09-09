FROM node:22-bookworm-slim

# 1. 安装基础工具、C编译器以及 git（必须）
RUN apt-get update && apt-get install -y \
    build-essential \
    python3 \
    git \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# 2. 全局安装 pnpm
RUN npm install -g pnpm

WORKDIR /app

# 3. 直接拷贝所有代码（保证工作区依赖和钩子脚本完整）
COPY . .

# 4. 安装依赖（--no-frozen-lockfile 避免平台架构微小差异导致的 lockfile 报错）
RUN pnpm install --no-frozen-lockfile

# 5. 执行项目编译
RUN pnpm run build

EXPOSE 3000

CMD ["pnpm", "start"]
