# Clickster

Clickster is a simple proof of concept for an api to store and query tracking events

## Dependencies

- Ruby Version 3.0.2
- Sqlite3

## Setup

Install the correct ruby version

```shell
$ rvm install 3.02
```

Install the ruby dependencies

```shell
$ bundle install --jobs=64
```

Setup the database

```shell
$ bundle exec rails db:setup
```

Run the test suite

```
$ bundle exec rspec
```

Start a server

```shell
$ bundle exec rails server
```

## Documentation

All API endpoints are documented using OpenAPI 3. After starting the server you can
find a rendering of the documentation at `/api/v1/docs`.

The openapi file can be found under `/app/api_docs/v1.yml`
