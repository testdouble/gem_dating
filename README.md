# GemDating

GemDating is a library for determining the relative age of a set of gems.

The primary use case is when evaluating a codebase for upgrades - a gem from 2017 may effectively be abandoned and could
cause trouble if you're targeting an upgrade to Ruby 4.1

## Usage

### Installation

`gem install gem_dating` or add it to your Gemfile:

```ruby
gem 'gem_dating', group: [:development]
```

### Running GemDating

This gem provides a *very* limited command line interface. It may be invoked with:

```bash
$ gem_dating [path/to/Gemfile]
```

Given a path to a Gemfile, GemDating will output a list of gems and their relative ages to the stdout stream.

For example:

```bash
$ gem_dating ~/code/my_app/Gemfile
``` 
to read the output in your terminal.

Or you can run
```bash
$ gem_dating ~/code/my_app/Gemfile > ~/code/my_app/gem_ages.txt
```
which will pipe the output into a text file. 


## Code of Conduct

This project follows Test Double's [code of
conduct](https://testdouble.com/code-of-conduct) for all community interactions,
including (but not limited to) one-on-one communications, public posts/comments,
code reviews, pull requests, and GitHub issues. If violations occur, Test Double
will take any action they deem appropriate for the infraction, up to and
including blocking a user from the organization's repositories.
