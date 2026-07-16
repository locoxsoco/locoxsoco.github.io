FROM ubuntu:latest
ENV DEBIAN_FRONTEND noninteractive

Label MAINTAINER Amir Pourmand

RUN apt-get update -y && apt-get install -y --no-install-recommends \
    locales \
    imagemagick \
    ruby-full \
    build-essential \
    zlib1g-dev \
    jupyter-nbconvert \
    inotify-tools procps && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*


# Dynamically find and update policy.xml if it exists
RUN find /etc -name "policy.xml" -exec sed -i -E 's/name="memory" value=".*"/name="memory" value="4GiB"/g' {} + && \
    find /etc -name "policy.xml" -exec sed -i -E 's/name="map" value=".*"/name="map" value="4GiB"/g' {} + && \
    find /etc -name "policy.xml" -exec sed -i -E 's/name="disk" value=".*"/name="disk" value="8GiB"/g' {} +

# Set environment variables as a fallback for ImageMagick limits
ENV MAGICK_MEMORY_LIMIT=4GiB \
    MAGICK_MAP_LIMIT=4GiB \
    MAGICK_DISK_LIMIT=8GiB

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen


ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    JEKYLL_ENV=production

# install jekyll and dependencies
RUN gem install jekyll bundler

RUN mkdir /srv/jekyll

ADD Gemfile /srv/jekyll

WORKDIR /srv/jekyll

RUN bundle install --no-cache
# && rm -rf /var/lib/gems/3.1.0/cache
EXPOSE 8080

COPY bin/entry_point.sh /tmp/entry_point.sh

CMD ["/tmp/entry_point.sh"]
