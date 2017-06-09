FROM ruby:2.2.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
ENV PHANTOMJS_VERSION=1.9.8
RUN cd /usr/local/share
RUN wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-${PHANTOMJS_VERSION}-linux-x86_64.tar.bz2
RUN tar xvf phantomjs-${PHANTOMJS_VERSION}-linux-x86_64.tar.bz2
RUN ln -sf /usr/local/share/phantomjs-${PHANTOMJS_VERSION}-linux-x86_64/bin/phantomjs /usr/local/bin
RUN mkdir /osra
WORKDIR /osra
ADD Gemfile /osra/Gemfile
ADD Gemfile.lock /osra/Gemfile.lock
RUN bundle install
ADD . /osra