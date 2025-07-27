# syntax = docker/dockerfile:1
ARG RUBY_VERSION=3.3.0
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim AS base

WORKDIR /rails

ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

ARG SECRET_KEY_BASE
ARG RAILS_MASTER_KEY

ENV SECRET_KEY_BASE=$SECRET_KEY_BASE
ENV RAILS_MASTER_KEY=$RAILS_MASTER_KEY

# --------------------------------
# Build stage
# --------------------------------
FROM base AS build

# Install packages needed to build gems + Node.js for vite
RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
      build-essential \
      git \
      libpq-dev \
      libvips \
      pkg-config \
      curl \
      ca-certificates \
      postgresql-client && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives

# Install Ruby gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

# Install JS dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy app source
COPY . .

# Build frontend assets via Vite
RUN npm run build

# Precompile Ruby assets
RUN bundle exec bootsnap precompile app/ lib/
RUN SECRET_KEY_BASE=DUMMY ./bin/rails assets:precompile

# --------------------------------
# Final stage
# --------------------------------
FROM base

RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
      curl \
      libvips \
      postgresql-client && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives

COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER rails:rails

ENTRYPOINT ["/rails/bin/docker-entrypoint"]
EXPOSE 3000
CMD ["./bin/rails", "server"]
