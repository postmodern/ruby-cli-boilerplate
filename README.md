# ruby-cli-boilerplate

This repository contains a boilerplate Ruby CLI class that can be used to
implement a basic zero-dependency CLI for other Ruby libraries.

## Features

* Zero-dependencies, making it ideal for adding a CLI to small libraries.
* Correctly handles `Ctrl^C` and broken pipe exceptions.
* Catches any other exceptions and prints a bug report.
* Defines the CLI as a class, making it easy to test.
* Comes with boilerplate RSpec tests.

## Other CLI libraries

If you want to build a CLI for a large Ruby app or framework, and
don't mind adding an extra dependency for a CLI library/framework, I recommend
the following Ruby CLI libraries:

* [cmdparse](https://cmdparse.gettalong.org/)
* [dry-cli](https://dry-rb.org/gems/dry-cli/)
* [command_kit](https://github.com/postmodern/command_kit.rb#readme)
