# Contributing

This contributing guide pertains to contributing to exercism problem sets
in individual languages, as well as the exercism Problem API (x-api),
which is a small application that delivers the problems in all of the
languages.

The problem API includes each of the language repositories as a git submodule.

Submodules can be a bit tricky to work with, but in this case it's worth it,
since contributing to a language track can be done with no dependencies on
other languages.

**You don't need to have a working Ruby development environment to contribute
problems in Haskell or Erlang!**

## Contributing to an Existing Language Track

Each language has its own repository, in the exercism GitHub organization. It
is named `x<language>`, e.g.

* [exercism/xelixir](https://github.com/exercism/xelixir)
* [exercism/xpython](https://github.com/exercism/xpython)

You can also navigate to each language repository from this repository via the
`problems` directory at the root of the repository. Each entry there is a link to
the relevant submodule's repository.

**If there are any special considerations when contributing to a language,
then these will be listed in the README for that specific repository.**

Each problem consists of:

* a test suite
* an example solution
* supporting files (optional)

The test suite forms the basis for the problem. The example solution will
_not_ be delivered as part of the problem, and is simply used as a sanity
check to make sure that the test suite makes sense.

In some language tracks the test suite is run against the example solution as
part of the CI process.

Supporting files could be anything from additional documentation
(`GETTING_STARTED.md`) or type definitions or helpful/boring/necessary
boilerplate.

### Existing Problems

To contribute to an existing problem, fork, fix, and submit a pull request as
usual.

It helps very much if the commit message contains the name of the problem,
e.g.

```plain
Clarify failure output in queen-attack
```

If you have fixes for more than one problem, please use branches and submit
multiple pull requests. This lets us merge simple and uncontroversial pull
requests quickly, while leaving the option open to ask for improvements and
have discussions in others.

If you have a global change, for example normalizing whitespace in all the
problems, then it's fine to submit that in a single pull request.

### New Problems

A problem must have a unique slug. This slug is used as

* the directory name within each language-specific repository
* the basename for the metadata files
* the entry in `config.json`

When creating a new problem there are a few things to keep in mind.

1. The metadata needs to exist in the exercism/x-common repository.
1. The problem needs an example solution.
1. The problem slug must be added to the `config.json`.

If you are adding an exercise that already exists in another language, then
the metadata files will already be present.

The example solution's file should contain the word `example` or `Example` in
it, to avoid delivering it as part of the problem.

The example is not shown to people, it doesn't have to be beautiful code, it's
just there to make sure that the test suite works.

CI runs a sanity check on the `config.json` using the `configlet` tool.
Download the archive for your platform and architecture from the [latest
release](https://github.com/exercism/configlet/releases/latest), unpack the
archive into your path.

To run the tool, call `configlet .` from the root of the repository of the
language track, or from elsewhere you can call it with the path to the
repository (e.g. `configlet /home/you/code/exercism/haskell`)

An exercise may have supporting files, such as type definitions.

### Nitpicking a Problem You Created

Once you've created a problem, you'll probably want to provide feedback to people who
submit solutions to it. Once the problem goes live, you can fetch it using the CLI:

```bash
$ exercism fetch <language> <problem>
```

Then submit the example solution that you wrote when creating the problem. This makes
the problem available to you in the nitpick menu.

Remember to mark it with "OK, I'm done" if you don't want other people to comment on it.

## Contributing to Metadata

The problem metadata is shared between all of the languages. This also lives
in a separate repository (http://github.com/exercism/x-common), and is a
collection of yaml, markdown, and json files. There are no development
dependencies whatsoever in this repository, it's all just plain text.

There are three metadata files that go in the
[x-common](https://github.com/exercism/x-common) repository.

* `<slug>.yml` - contains `blurb`, `source`, and `source_url`
* `<slug>.md` - contains the long-form description of the exercise
* `<slug>.json` - contains standard test data for the exercise

The .md and .yml are sewn into a README that gets delivered with the exercise.
The .json can be used as a source of test cases for the test program.
See
[exercism/x-common/README.md](https://github.com/exercism/x-common/blob/master/README.md)
for more details of the .json file.

The `<slug>.md` for each problem should contain a high-level, generic
description of the problem.

It should avoid specifics about data-structures, edge-cases, and error
handling, since each language track can choose to handle these things quite
differently.

## Contributing a New Language Track

If you're interested in adding problems for a language that we don't yet have,
[email me](mailto:kytrinyx@exercism.io) or [tweet at me](https://twitter.com/kytrinyx)
and I'll set up a new repo for that language.

Then you can fork and clone per usual.

Each language will need at least 10 problems in order to launch, as well as a
small handful of people who can kick off the nitpicking. These people should
have a good grasp of the styles and idioms in use in that language.

In addition to a problem set and some initial mentors, we also need:

1. A help topic: [`lib/app/articles/help/setup/$LANGUAGE.md`](https://github.com/exercism/exercism.io/blob/master/lib/redesign/articles/help/setup/)
1. An entry in
[`lib/exercism/code.rb`](https://github.com/exercism/exercism.io/blob/master/lib/exercism/code.rb)
to define the file extension for that language.
1. (maybe) an addition to the [exercism CLI](https://github.com/exercism/cli)
that instructs the cli application how to recognize test files to prevent
people from accidentally submitting tests as solutions.

### Beta-Testing a Language Track

Provided that I've remembered to add the language as a submodule to the x-api
repository, it should be enough to set `active` to `false` in the
`config.json`. Then the next time that I update the submodules (more or less
daily) it will be available via the `exercism` CLI.

You can test your new language track by fetching the assignments directly,
i.e. `exercism fetch cpp bob`.

This will allow you to do some dry-run tests of fetching exercises,
double checking the instructions for each problem and submitting the
problem solution for peer review.

It is recommended that you configure a [Travis continuous integration build](http://travis-ci.org)
with your language track to verify that your example problem solutions
satisfy the tests provided for each problem.

You can include advice and helpful links for your language track in the
`SETUP.md` file.

## config.json

There are a number of keys in the `config.json` of each language repository.

* `problems` - these are actively served via `exercism fetch`
* `deprecated` - these were implemented, but aren't served anymore
* `foregone` - these must not be implemented in this language
* `ignored` - these directories do not contain problems

The `configlet` tool uses those categories to ensure that

1. all the `problems` are implemented,
2. `deprecated` problems are not actively served as problems, and
3. `foregone` problems are not implemented.

In addition, it will complain about problems that are implemented but are not
listed in the config under the `problems` key. This is where the `ignored` key
is useful. Ignored directories don't get flagged as unimplemented problems.

A problem might be foregone for a number of reasons, typically because it's a
bad exercise for the language.

## Using the CLI Locally

The `~/.exercism.go` configuration file for the CLI contains a field
'hostname' which defaults to 'http://exercism.io'. You can change this to
'http://localhost:4567' to run against your development environment.

If you are also serving exercises locally via `x-api`, you can configure the
exercism.io app to talk to `x-api` locally by exporting an environment
variable:

```bash
$ export EXERCISES_API_URL=http://localhost:9292
```

## Contributing to the Problem API

Fork and clone per usual, then run:

```bash
$ bundle install
$ git submodule init
$ git submodule update
```

### Running the Tests

Run the tests with `rake`:

```bash
$ bundle exec rake
```

** If you do not go through the [Getting Started](#getting-started) section your tests will _not_ pass.**

You can run individual test suites using the `ruby` command:

```bash
$ ruby path/to/something_test.rb
```

### Running Locally

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

### The Problem Data

The supporting code for a given problem can be found in language-specific
subdirectories under the `problems` directory.

**If you're not seeing any problems it is probably because you haven't
updated or inititialized the submodules. Be sure to work through the
[Getting Started](#getting-started) section.**

Each language-specific directory is a git submodule. If you wish to make
changes to a problem, look for the corresponding repository on GitHub under
`exercism/x{LANGUAGE_NAME}`.

So, for example, the Scala examples can be found in this repository:

```bash
$ ls problems/scala
```

The corresponding git repository is at
[github.com/exercism/xscala](https://github.com/exercism/xscala).

The READMEs are constructed using shared metadata in the `metadata` directory.
This is also a git submodule, and if you wish to make changes to it, the codebase
can be found on GitHub under [exercism/x-common](https://github.com/exercism/x-common).

### Abstractions

The core ideas in the codebase are:

* [Progression](lib/xapi/progression.rb) - a complete list of all the problems currently available for
  a language, in the order that they will be delivered by default. This is
  based on the contents of the `EXERCISES.txt` file in the language-specific
  repository.
* [Problem](lib/xapi/problem.rb) - the basic unit of work in exercism. It is in a given language,
  and has a `slug` that identifies it.
  An exercise consists of a `Readme` and `Code`.
* [Readme](lib/xapi/readme.rb) - a language-independent explanation of the problem to be solved.
* [Code](lib/xapi/code.rb) - supporting code to solve the problem. In its most basic form, it
  consists of a test suite, but there can be other supporting files (class
  or type definitions, metadata files, etc).

There is also the concept of `Homework` which wraps the process of getting
a user's current exercise set from exercism.io, and getting all the relevant problems.

**NOTE** A _problem_ is a README and test suite/supporting code (language+slug). An _exercise_ is a problem worked by a user.

### Code Arrangement

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
