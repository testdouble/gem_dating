# GemDating

`gem_dating` is a library for determining the relative age of a set of gems.

The primary use case is when evaluating a codebase for upgrades - a gem from 2017 may effectively be abandoned and could cause trouble if you're targeting an upgrade to Ruby 4.1

`gem_dating` avoids utilizing Bundler, and intends to be useful where you want to evaluate a set of gems without
the overhead of a full bundle install. If you've got a valid bundle you should consider the built in
[bundle-outdated](https://bundler.io/v2.4/man/bundle-outdated.1.html), or other available tools for interacting
with your Gemfile, like [libyear-bundler](https://github.com/jaredbeck/libyear-bundler).

## Usage

If you have rubygems 3.4.8 or later installed, you can skip installation and just run via `gem exec gem_dating [[path/to/Gemfile]`


### Gem Installation

`gem install gem_dating` or add it to your Gemfile:

```ruby
gem 'gem_dating', group: [:development], require: false
```

### Running GemDating

This gem provides a small command line interface. It may be invoked with:

```bash
$ gem_dating
```

By default, GemDating will look for a Gemfile in the current directory.
If it finds one, it will output a list of gems and their relative ages to the stdout stream.

You may also pass a path to a Gemfile as an argument:

```bash
$ gem_dating ~/code/my_app/Gemfile
``` 

GemDating leans on `$stdout`, so you can pipe the output to a file if you'd like:
```bash
$ gem_dating ~/code/my_app/Gemfile > ~/code/my_app/gem_ages.txt
```

[TablePrint](https://github.com/arches/table_print) formats the output to something like this:

```bash
NAME        | VERSION | DATE
------------|---------|-----------
rest-client | 2.1.0   | 2019-08-21
rails       | 7.0.5   | 2023-05-24
graphql     | 2.0.22  | 2023-05-17
```

gem_dating also includes some other useable patterns, if you invoke it within an IRB session. It currently supports
passing in a string of a gem name, or a path to a Gemfile. You can then parse those to an array of `Gem::Specifications`,
a minimal hash, or the Table output you'd see in the CLI.

```ruby
# irb
# #:001 >

require "gem_dating"

dating = GemDating.from_string("rails")

more_dating = GemDating.from_file("path/to/Gemfile")


dating.to_a
# => [Gem::Specification.new do |s|
# s.name = "rails"
# s.version = Gem::Version.new("7.0.5")
# s.installed_by_version = Gem::Version.new("0") ...etc

dating.to_h
# =>  {"rails"=>{"name"=>"rails", "version"=>"7.0.5", "date"=>"2023-05-24"}}

more_dating.table_print
# =>
# NAME        | VERSION | DATE
# ------------|---------|-----------
# rails       | 7.0.5   | 2023-05-24
# ...etc
```



## Code of Conduct

This project follows Test Double's [code of
conduct](https://testdouble.com/code-of-conduct) for all community interactions,
including (but not limited to) one-on-one communications, public posts/comments,
code reviews, pull requests, and GitHub issues. If violations occur, Test Double
will take any action they deem appropriate for the infraction, up to and
including blocking a user from the organization's repositories.
