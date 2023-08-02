# GemDating

GemDating is a library for determining the relative age of a set of gems.

The primary use case is when evaluating a codebase for upgrades - a gem from 2017 may effectively be abandoned and could
cause trouble if you're targeting an upgrade to Ruby 4.1

## Usage

### Installation

`gem install gem_dating` or add it to your Gemfile:

```ruby
gem 'gem_dating', group: [:development], require: false
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

The command line output will look something like this:

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
