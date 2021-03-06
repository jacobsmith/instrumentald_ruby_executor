# InstrumentalD Agent

This app is designed to be a (mostly) plug-and-play InstrumentalD statistics collator. After configuring a few ENV variables, the process should automatically reach out to those services, collect the necessary statistics, and send them to the Instrumental account for graphing and analyzing.

It is designed to run on top of [heroku-buildpack-instrumentald](https://github.com/jacobsmith/heroku-buildpack-instrumentald) for easy configuration.

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy?template=https://github.com/jacobsmith/instrumentald_ruby_executor)

## Configuration

The following ENV vars can be set:

`INSTRUMENTALD_PROJECT_TOKEN` # must be the Instrumental Project Token found in the Instrumental Settings Page

`INSTRUMENTALD_SYSTEM_METRICS` # may be either `true`, `false`, or a semi-colon delimited list of valid system metrics

Each of the following accepts a `;` delimited list of URLs. It also supports a single URL (no `;` necessary) as that is a common use case.

`INSTRUMENTALD_DOCKER_URLS`

`INSTRUMENTALD_REDIS_URLS`

`INSTRUMENTALD_MEMCACHED_URLS`

`INSTRUMENTALD_NGINX_URLS`

`INSTRUMENTALD_MYSQL_URLS`

`INSTRUMENTALD_POSTGRESQL_URLS`


### Heroku

If you have connected a Heroku database, it will add the env var in `DATABASE_URL` to the list of urls in `INSTRUMENTALD_POSTGRESQL_URLS`, meaning that it should pick up changes in that heroku database (rotating credentials, etc.)

### Gotchas

The process that configures the `toml` file has some rudimentary validation in it to help ensure the following conditions are met.
  - If you are on Heroku Postgres, you *must* append `?sslmode=require` to the end of your PostgreSQL urls.
  - Redis urls must *not* have `redis://` prepended
  - Memcached currently does *not* work with SASL (so, no memcachier support yet). An [open issue](https://github.com/influxdata/telegraf/issues/2613) is ready to be worked on if anyone wants to tackle it!
  - `DOCKER`, `NGINGX, and `MYSQL` have *not* been tested yet. They should work the same as the others, though some debugging may be necessary to get them to work properly. Please update this README with any information you find!
