# x-API

[![Build Status](https://travis-ci.org/exercism/x-api.png?branch=master)](https://travis-ci.org/exercism/x-api)
[![Coverage Status](https://coveralls.io/repos/exercism/x-api/badge.png)](https://coveralls.io/r/exercism/x-api)
[![Code Climate](https://codeclimate.com/github/exercism/x-api.png)](https://codeclimate.com/github/exercism/x-api)
[![Dependency Status](https://gemnasium.com/exercism/x-api.png)](https://gemnasium.com/exercism/x-api)

Exercism exercise API

This codebase collects all the exercises and metadata that make up the problem
sets for exercism.io.

The exercises for each language are stored in separate repositories, included
here as git submodules. This codebase provides an API for serving the Exercism
exercises to people using the Exercism command-line client.

## Getting Started

Fork and clone per usual, then run:

```bash
$ bundle install
$ git submodule init
$ git submodule update
```

## Running Locally

Run the server with `rackup`:

```bash
$ rackup
Puma 2.7.1 starting...
* Min threads: 0, max threads: 16
* Environment: development
* Listening on tcp://0.0.0.0:9292...
```

At this point you can navigate to an existing endpoint in your browser, e.g.
[localhost:9292/tracks/ruby/bob](http://localhost:9292/tracks/ruby/bob)

**If the endpoint does not return exercism problem data, it is probably because
you haven't updated or inititialized the submodules. Be sure to work through the
[Getting Started](https://github.com/exercism/x-api/blob/master/README.md#getting-started)
section of the README.**

## Tests

Run the entire test suite with `rake`, or an individual test file with `ruby`:

```bash
$ bundle exec rake # runs the entire suite
```

```bash
ruby path/to/file_test.rb # runs only the tests in file_test.rb
```

Some of the API tests use approvals, which is a form of Golden Master testing.
The test captures the entire body of the response, dumps it to a file, and compares
it to the previously accepted version (which lives in a fixture file).

If the two versions are all good, then fine. The test passes. If they're different,
then the test fails.

View the diffs using the approvals script:

```bash
approvals verify -d diff -a
```

`-d` is for the diff library, use whatever you're comfortable with.
`opendiff` is nice if you don't already have a preference.

`-a` is a boolean option that, if passed, will ask you if you want to accept the change.

Accepting the change means that the new output gets copied over the old one, and any new
test runs will be compared to this output.

The approvals tests are particularly handy when tweaking the view templates.

## View Templates

The entire project serves up JSON. It uses the [petroglyph](https://github.com/kytrinyx/petroglyph)
library to write the views. Petroglyph is a tiny library that essentially lets you write some simple
ruby to define the JSON structure.

## Contributing

Please see the [CONTRIBUTING](CONTRIBUTING.md) guidelines in the root of this repository.

## License

The MIT License (MIT)

Copyright (c) 2014 Katrina Owen, _@kytrinyx.com
