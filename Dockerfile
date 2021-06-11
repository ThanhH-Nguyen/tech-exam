FROM ruby:2.6.6

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
WORKDIR /app

# not Ruby knowledgeable so COPY everything (exclusion noted in dockerignore)
COPY . /app/
RUN gem install bundler -v 2.1.4 \
    && bundle install

EXPOSE 8080
CMD ["bundle", "exec", "rackup", "config.ru", "-o", "0.0.0.0", "-p", "8080"]