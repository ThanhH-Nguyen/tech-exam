### Overview

It is a simple app to create alerts and list them.

#### Dependencies

Ruby 2.6.6 is required.

Before staring, make sure you run bundle:

``` bash
gem install bundler -v 2.1.4
bundle install
```

The app requires MySQL instance to run. In `production` environment please set following ENV:

```bash
DB_HOST
DB_USERNAME
DB_PASSWORD
DB_NAME
```

Once database is running, to properly initialize the database please run following commands:

```
bundle exec rake db:create
bundle exec rake db:migrate
```

You should set `RACK_ENV=production` if you run it in production environment.

#### Deployment

The application is started by the command `bundle exec rackup config.ru -o 0.0.0.0 -p 8080`.

There are two endpoints available:

* GET `/alerts` - lists all alerts in JSON format
* POST `/alerts` - creates alert with a `message` e.g. `curl -X POST http://0.0.0.0:8080/alerts --data 'message=message'`
* GET `/health_check` - health check
