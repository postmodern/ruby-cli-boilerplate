# frozen_string_literal: true
require 'optparse'

class CLI

  # The CLI name.
  PROGRAM_NAME = "cli"

  # The CLI version
  VERSION = '0.1.0'

  # The URL to report bugs to.
  BUG_REPORT_URL = "https://github.com/FIXME/FIXME/issues/new"

  # The CLI's option parser.
  #
  # @return [OptionParser]
  attr_reader :option_parser

  #
  # Initializes the CLI.
  #
  def initialize
    @option_parser = option_parser

    # FIXME: initialize additional variables here
  end

  #
  # Initializes and runs the CLI.
  #
  # @param [Array<String>] argv
  #   Command-line arguments.
  #
  # @return [Integer]
  #   The exit status of the CLI.
  #
  def self.run(argv=ARGV)
    new().run(argv)
  rescue Interrupt
    # https://tldp.org/LDP/abs/html/exitcodes.html
    return 130
  rescue Errno::EPIPE
    # STDOUT pipe broken
    return 0
  end

  #
  # Runs the CLI.
  #
  # @param [Array<String>] argv
  #   Command-line arguments.
  #
  # @return [Integer]
  #   The return status code.
  #
  def run(argv=ARGV)
    argv = begin
             @option_parser.parse(argv)
           rescue OptionParser::ParseError => error
             print_error(error.message)
             return -1
           end

    # FIXME: add CLI logic here
    do_stuff
  rescue => error
    print_backtrace(error)
    return -1
  end

  def do_stuff
  end

  #
  # The option parser.
  #
  # @return [OptionParser]
  #
  def option_parser
    OptionParser.new do |opts|
      opts.banner = "usage: #{PROGRAM_NAME} [options] ARG ..."

      opts.separator ""
      opts.separator "Options:"

      # FIXME: add additional options here

      opts.on('-V','--version','Print the version') do
        puts "#{PROGRAM_NAME} #{VERSION}"
        exit
      end

      opts.on('-h','--help','Print the help output') do
        puts opts
        exit
      end
    end
  end

  #
  # Prints an error message to stderr.
  #
  # @param [String] error
  #   The error message.
  #
  def print_error(error)
    $stderr.puts "#{PROGRAM_NAME}: #{error}"
  end

  #
  # Prints a backtrace to stderr.
  #
  # @param [Exception] exception
  #   The exception.
  #
  def print_backtrace(exception)
    $stderr.puts "Oops! Looks like you've found a bug!"
    $stderr.puts "Please report the following text to: #{BUG_REPORT_URL}"
    $stderr.puts
    $stderr.puts "```"
    $stderr.puts "#{exception.full_message}"
    $stderr.puts "```"
  end

end
