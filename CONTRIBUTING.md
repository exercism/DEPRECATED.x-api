# Contributing

## Getting Started

Fork and clone per usual, then run:

```bash
$ bundle install
$ git submodule init
$ git submodule update
```

## Running the Tests

Run the tests with `rake`:

```bash
$ bundle exec rake
```

** If you do not go through the _Getting Started_ section your tests will _not_ pass.**

You can run individual test suites using the `ruby` command:

```bash
$ ruby path/to/something_test.rb
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
[localhost:9292/exercises/ruby/bob](http://localhost:9292/exercises/ruby/bob)

## The Exercise Data

The supporting code for a given exercise can be found in language-specific
subdirectories under the `exercises` directory.

Each language-specific directory is a git submodule. If you wish to make
changes to an exercise, look for the corresponding repository on GitHub under
`exercism/x{LANGUAGE_NAME}`.

So, for example, the Scala examples can be found in this repository:

```bash
$ ls exercises/scala
```

The corresponding git repository is at
[github.com/exercism/xscala](https://github.com/exercism/xscala).

The READMEs are constructed using shared metadata in the `metadata` directory.
This is also a git submodule, and if you wish to make changes to it, the codebase
can be found on GitHub under [exercism/x-common](https://github.com/exercism/x-common).

If you have global instructions for a given language, it can go in a file
named `SETUP.md` in the root of the language repository. These will be
included in the README for each exercise.

## Abstractions

The core ideas in the codebase are:

* `Progression` - a complete list of all the exercises currently available for
  a language, in the order that they will be delivered by default. This is
  based on the contents of the `EXERCISES.txt` file in the language-specific
  repository.
* `Exercise` - the basic unit of work in exercism. It is in a given language,
  and has a `slug` that identifies which particular problem is being solved.
  An exercise consists of a `Readme` and `Code`.
* `Readme` - a language-independent explanation of the problem to be solved.
* `Code` - supporting code to solve the problem. In its most basic form, it
  consists of a test suite, but there can be other supporting files (class
  or type definitions, metadata files, etc).
* `Lesson` - a subset of exercises in a progression, based on what a person
  has previously worked on.
* `Homework` - a collection of lessons.

There is also the concept of `UserHomework` which wraps the process of getting
a user's current problem set from exercism.io, and then producing homework
from it.

## Code Arrangement

The sinatra app lives in `lib/app`, and the business logic lives in
`lib/xapi`. To determine whether something is business logic or web
application logic, think about whether or not a different interface (say,
perhaps a command-line interface) would also need that behavior.

The tests live under `test`, and the path to the test file will mirror the
path to the code file, except with `test` rather than `lib`:

```bash
lib/app/routes/demo.rb
test/app/routes/demo_test.rb
```

There could be exceptions to this, but they are rare.
