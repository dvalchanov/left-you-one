# Left You One

A Rails application using PostgreSQL and Tailwind CSS.

## Requirements

- Ruby 3.4.7
- PostgreSQL

## Setup

```sh
bin/setup --skip-server
```

This installs the gems and creates or updates the development and test databases.

## Development

```sh
bin/dev
```

The application runs at <http://localhost:3000>. Tailwind rebuilds automatically.
Emails delivered in development open in the default browser through `letter_opener`.

## Tests

```sh
bin/rails test
```
