# x-API

[![Build Status](https://travis-ci.org/exercism/x-api.png?branch=master)](https://travis-ci.org/exercism/x-api)
[![Coverage Status](https://coveralls.io/repos/exercism/x-api/badge.png)](https://coveralls.io/r/exercism/x-api)
[![Code Climate](https://codeclimate.com/github/exercism/x-api.png)](https://codeclimate.com/github/exercism/x-api)
[![Dependency Status](https://gemnasium.com/exercism/x-api.png)](https://gemnasium.com/exercism/x-api)

Exercism exercise API

## Getting Started

Fork and clone per usual, then run:

```bash
$ git submodule init
$ git submodule update
```

## Running Locally

Once you clone the repository and init/update the submodules
you just bundle install then run `rackup`:

```bash
$ bundle install
...
$ rackup                                                                                                       [9:15:05]
Puma 2.7.1 starting...
* Min threads: 0, max threads: 16
* Environment: development
* Listening on tcp://0.0.0.0:9292...
```

At this point you can navigate your browser to an endpoint,
e.g. http://0.0.0.0:9292/exercises/ruby/bob

## Running Tests

Once you clone, init then update submodules, and get the app running locally you can finally run the tests:

```bash
bundle exec rake
```

> If you do not go through the Getting Started and Running Locally sections your tests will **not** pass.

## License

The MIT License (MIT)

Copyright (c) 2014 Katrina Owen, _@kytrinyx.com
