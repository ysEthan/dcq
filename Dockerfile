FROM python:3.11

WORKDIR /app

RUN python -m pip install --upgrade pip




# 替换为国内源
RUN sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list && \
    sed -i 's|security.debian.org/debian-security|mirrors.aliyun.com/debian-security|g' /etc/apt/sources.list

# 更新包列表并安装必要的包
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    # 安装你需要的其他包
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 设置 Python 的 pip 源为国内源
RUN pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/




# optimizing the docker caching behaviour
COPY requirements.txt .
RUN python -m pip install --no-cache-dir -r requirements.txt
COPY . .

RUN python manage.py collectstatic --noinput

CMD uwsgi --http=0.0.0.0:80 --module=backend.wsgi
