# Contributing

This contributing guide pertains to the exercism Problem API (x-api),
which is a small application that delivers the problems in all of the
languages.

The problem API includes each of the language repositories as a git submodule.

Submodules can be a bit tricky to work with, but in this case it's worth it,
since contributing to a language track can be done with no dependencies on
other languages.

**You don't need to have a working Ruby development environment to contribute
problems in Haskell or Erlang!**

### Table of Contents
* [Abstractions](#abstractions)
* [Code Arrangement](#code-arrangement)
* [config.json](#configjson)
* [configlet](#configlet)
* [CLI](#cli)
* [Problem API](#problem-api)
* [Track Anatomy](#track-anatomy)


### Abstractions
---

We have settled on the following terminology:

* **Language** - A programming language.
* **Track** - A collection of exercises in a programming language.
* **Problem** - A generic problem description.
* **Exercise** - A language-specific implementation of a problem description.

Unfortunately, the codebase uses all sorts of names for things; we're still
working on cleaning that up.

### Code Arrangement
---

* `v1/` - legacy API, has some v2 endpoints. Yeah, sorry about that.
* `v3/` - new API.
* `lib/xapi` - business logic.
* `test/` - automated tests

## CLI
### Using the CLI Locally
---

The `~/.exercism.go` configuration file for the CLI contains a field
'hostname' which defaults to 'http://exercism.io'.

To reconfigure the CLI to talk to your local development environment, either
edit file directly, or use the `configure` command:

    exercism configure --host='http://localhost:4567'

If you are also serving exercises locally via the `x-api` app, you can configure
your local exercism.io app to talk to the problems api by exporting an environment
variable:

```bash
$ export EXERCISES_API_URL=http://localhost:9292
```

### Track Anatomy

Each track should have the following structure:

```bash
├── .gitignore
├── .travis.yml
├── LICENSE
├── README.md
├── SETUP.md
├── bin
│   └── fetch-configlet
├── config.json
├── docs
│   ├── ABOUT.md
│   ├── INSTALLATION.md
│   ├── LEARNING.md
│   ├── RESOURCES.md
│   └── TESTS.md
└── exercises
    └── hello-world
        ├── hello-world_example.file
        ├── hello-world.file
        └── hello-world_test.file
```

The example template for a track can be found at [x-template](https://github.com/exercism/x-template).

* `LICENSE` - The MIT License (MIT)
* `README.md` - a thorough explanation of how to contribute to the track.
* `SETUP.md` - this should contain any track specific, problem agnostic information that will be included in the README.md of every exercise when fetched. Include information on how to run tests, how to get help, etc.
* `bin` - scripts and other files related to running the track's tests, etc.
* `config.json` - the track-level configuration. It contains configuration for which exercises (and in which order) are a part of the track, which exercises are deprecated, the track id, name of the language, and the location of the repository. Optionally, it may include a regex to recognize what files are part of the test suite (usually `/test/i`, but sometimes `/spec/i` or other things). If the test pattern is not included, then `/test/i` is assumed.
* `docs` - the documentation for the track.These files are served to the exercism.io help site via the x-api. It should contain at minimum:

    - `INSTALLATION.md` - about how to get the track's language set up locally.
    - `TESTS.md` - how to run the tests for the track's individual exercises.

    Some nice to haves:

    - `ABOUT.md` - a short, friendly blurb about the track's language. What types of problems does it solve really well? What is it typically used for?
    - `LEARNING.md` - a few notes about where people might want to go to learn the track's language from scratch. These are the the resources you need only when first getting up to speed with a language (tutorials, blog posts, etc.).
    - `RESOURCES.md` - references and other useful resources. These resources are those that would commonly be used by a developer on an ongoing basis (core language docs, api docs, etc.).

* `exercises` - all exercises for the track should live in subdirectories of this directory. Each exercise should have a test file, an example file that should pass all tests, and a template file that is a stub to help the user get started with the exercise. The example file should be used for the CI build.