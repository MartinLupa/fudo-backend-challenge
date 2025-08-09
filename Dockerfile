# https://hub.docker.com/r/jsixc/ruby-rack-app/dockerfile
FROM ruby:3.4.5

# Install node for asset building
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

RUN useradd -m -u 1000 app

WORKDIR /products-api

ENV SERVER_PORT=3000 \
    RACK_ENV="development" \
    DATABASE_URL="postgres://user:password@db:5432/fudo_db" \
    REDIS_URL="redis://default@redis:6379/0"

COPY app app
COPY app.rb config.ru Gemfile AUTHORS openapi.yaml ./
COPY db db

RUN bundle install

USER app