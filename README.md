# x-API

[![Build Status](https://travis-ci.org/exercism/x-api.svg?branch=master)](https://travis-ci.org/exercism/x-api)
[![Coverage Status](https://coveralls.io/repos/exercism/x-api/badge.svg)](https://coveralls.io/r/exercism/x-api)
[![Code Climate](https://codeclimate.com/github/exercism/x-api.svg)](https://codeclimate.com/github/exercism/x-api)
[![Dependency Status](https://gemnasium.com/exercism/x-api.svg)](https://gemnasium.com/exercism/x-api)
[![Supporting 24 Pull Requests](https://img.shields.io/badge/Supporting-24%20Pull%20Requests-red.svg)](https://24pullrequests.com)

**Exercism exercise API**

This codebase provides an API for delivering Exercism
exercises. This is consumed both by the Exercism command-line client,
as well as the Exercism website.

## Getting Started

The API is implemented in Ruby as a Sinatra application.

Fork and clone per usual, then run:

```bash
$ bundle install
```

## Terminology

We've struggled a bit with the terminology, and the project currently has a mix of
old and new.

Here's the terminology we're working towards:

* _Language_ - the name of a programming language, e.g. _C++_.
* _Track_ - a collection of exercises in a programming language.
* _Track ID_ - a url-friendly version of the language name, e.g. `cpp`.
* _Problem_ - a high-level, language-independent description of a problem to solve.
* _Implementation_ - a language-specific implementation of a problem. This contains a README and a test suite.

## Code Arrangement

```
.
├── api             # sinatra APIs
│   ├── helpers
│   ├── helpers.rb  # helpers used by both APIs
│   ├── services    # services used by both APIs
│   ├── v1          # API v1 routes and views (also contains some hacky v2 stuff)
│   ├── v1.rb
│   ├── v3          # API v3 routes and views
│   └── v3.rb
└── lib/xapi.rb     # application settings & logic
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

## Tests

Run the entire test suite with `rake`.

```bash
$ bundle exec rake # runs the entire suite
```

To run individual tests, you can use the `ruby` command directly:

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

Accepting the change means that the new output gets copied over the old one. Running the
test again will compare against this new output.

The approvals tests are particularly handy when tweaking the view templates.

## View Templates

The entire project serves up JSON. It uses the [petroglyph](https://github.com/kytrinyx/petroglyph)
library to write the views. Petroglyph is a tiny library that essentially lets you write some simple
ruby to define the JSON structure.

## Contributing

Please see the [CONTRIBUTING](CONTRIBUTING.md) guidelines in the root of this repository.

## Releasing

To update all of the language track data with their latest commits, run:

```
bundle update trackler
```

Then commit the changes (`git commit -m "Update trackler"`) and push to both GitHub and Heroku.

## License

The MIT License (MIT)

Copyright (c) 2014 Katrina Owen, _@kytrinyx.com
