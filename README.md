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

## Tests

Run the entire test suite with `rake`, or an individual test file with

```bash
ruby path/to/file_test.rb
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
