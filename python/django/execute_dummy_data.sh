#!/bin/bash

# PostgreSQL用のダミーデータ挿入スクリプト
# 使用方法: ./execute_dummy_data.sh

echo "ダミーデータを挿入します..."

# Docker Compose環境の場合
if [ -f "compose.yml" ] || [ -f "docker-compose.yml" ]; then
    echo "Docker Compose環境でPostgreSQLに接続します..."
    docker compose exec -T postgres psql -U pguser -d perf < insert_dummy_data.sql
else
    # ローカルPostgreSQLの場合
    echo "ローカルPostgreSQLに接続します..."
    psql -h localhost -U pguser -d perf < insert_dummy_data.sql
fi

echo "ダミーデータの挿入が完了しました。"