FROM node:20-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    tzdata \
    python3 \
    make \
    g++ \
    curl \
    ca-certificates \
    && ln -fs /usr/share/zoneinfo/Asia/Ho_Chi_Minh /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY package.json ./
RUN npm install better-sqlite3 --no-save

COPY . .

RUN mkdir -p dist/build/Release && \
    cp node_modules/better-sqlite3/build/Release/better_sqlite3.node dist/build/Release/better_sqlite3.node && \
    rm -rf node_modules

RUN chmod +x docker-entrypoint.sh

EXPOSE 3000

ENV TZ=Asia/Ho_Chi_Minh
ENV NODE_ENV=production
ENV PORT=3000
ENV HOST=0.0.0.0
ENV IS_DOCKER=true
ENV SKIP_LICENSE=true

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD curl -f http://localhost:3000/api/v1/system/common-settings || exit 1

ENTRYPOINT ["./docker-entrypoint.sh"]