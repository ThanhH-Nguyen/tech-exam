FROM ruby:2.6.6

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client \
    && adduser --disabled-password appuser

USER appuser
WORKDIR /app

# not Ruby knowledgeable so COPY everything (exclusion noted in dockerignore)
COPY --chown=appuser . /app/
RUN gem install bundler -v 2.1.4 \
    && bundle install

EXPOSE 8080
ENTRYPOINT ["bundle", "exec", "rackup", "config.ru"]
CMD ["-o", "0.0.0.0", "-p", "8080"]