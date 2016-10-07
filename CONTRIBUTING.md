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
* [Track Anatomy](https://github.com/exercism/x-common/blob/master/CONTRIBUTING.md#track-anatomy)

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
