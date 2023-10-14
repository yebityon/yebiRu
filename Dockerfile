FROM ruby:3.0

RUN apt-get update && \
    apt-get install -y build-essential \
                       nodejs \
                       yarn \
                       postgresql-client \
                       && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# ホストのGemfileとGemfile.lockをコピー
COPY Gemfile Gemfile.lock ./

# Gemをインストール
RUN gem install bundler && \
    bundle install --jobs 4