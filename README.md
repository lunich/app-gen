# Description

A simple gem to generate a new ruby application skeleton.

## Installation

```
gem install ruby-app-gen
```

## Simple example

To generate a new ruby application run this:

```
app-gen generate my-app ~/Work/
```

This would generate a new ruby application with DB support in `~/Work/my-app`.

## Features

[Zeitwerk](https://github.com/fxn/zeitwerk) used as a code loader

[Active Record](https://github.com/rails/rails/tree/main/activerecord) used as an ORM

[SQLite3](https://www.sqlite.org/index.html) used as a default database

## Commands

### Generate

```
Usage:
  app-gen generate APP_NAME PATH

Options:
  [--force]                      # overrides all the application files is exist
  [--database], [--no-database]  # generates DB related files
                                 # Default: true
```

### Help

```
Commands:
  app-gen generate APP_NAME PATH  # generate a ruby application skeleton
  app-gen help [COMMAND]          # Describe available commands or one specific command
```
