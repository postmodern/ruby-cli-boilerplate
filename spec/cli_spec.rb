require 'spec_helper'
require 'cli'

describe CLI do
  describe "#initialize" do
    it "must initialize #option_parser" do
      expect(subject.option_parser).to be_kind_of(OptionParser)
    end

    # FIXME: add additional #initialize specs here
  end

  describe "#print_error" do
    let(:error) { "error!" }

    it "must print the program name and the error message to stderr" do
      expect {
        subject.print_error(error)
      }.to output("#{described_class::PROGRAM_NAME}: #{error}#{$/}").to_stderr
    end
  end

  describe "#print_backtrace" do
    let(:exception) { RuntimeError.new("error!") }

    it "must print the program name and the error message to stderr" do
      expect {
        subject.print_backtrace(exception)
      }.to output(
        %r{Oops! Looks like you've found a bug!
Please report the following text to: #{Regexp.escape(described_class::BUG_REPORT_URL)}

```}m
      ).to_stderr
    end
  end

  describe "#option_parser" do
    it do
      expect(subject.option_parser).to be_kind_of(OptionParser)
    end

    describe "#parse" do
      # FIXME: add additional option specs here

      %w[-V --version].each do |flag|
        context "when given #{flag}" do
          let(:argv) { [flag] }

          it "must print the CLI's version" do
            expect(subject).to receive(:exit)

            expect {
              subject.option_parser.parse(argv)
            }.to output("#{described_class::PROGRAM_NAME} #{described_class::VERSION}#{$/}").to_stdout
          end
        end
      end

      %w[-h --help].each do |flag|
        context "when given #{flag}" do
          let(:argv) { [flag] }

          it "must print the option parser --help output" do
            expect(subject).to receive(:exit)

            expect {
              subject.option_parser.parse(argv)
            }.to output("#{subject.option_parser}").to_stdout
          end
        end
      end
    end
  end

  describe ".run" do
    subject { described_class }

    context "when Interrupt is raised" do
      before do
        expect_any_instance_of(described_class).to receive(:run).and_raise(Interrupt)
      end

      it "must exit with 130" do
        expect(subject.run([])).to eq(130)
      end
    end

    context "when Errno::EPIPE is raised" do
      before do
        expect_any_instance_of(described_class).to receive(:run).and_raise(Errno::EPIPE)
      end

      it "must exit with 0" do
        expect(subject.run([])).to eq(0)
      end
    end
  end

  describe "#run" do
    # FIXME: add additional specs here

    context "when an invalid option is given" do
      let(:opt) { '--foo' }

      it "must print '#{described_class::PROGRAM_NAME}: invalid option ...' to $stderr and exit with -1" do
        expect {
          expect(subject.run([opt])).to eq(-1)
        }.to output("#{described_class::PROGRAM_NAME}: invalid option: #{opt}#{$/}").to_stderr
      end
    end

    context "when another type of Exception is raised" do
      let(:exception) { RuntimeError.new("error!") }

      before do
        expect(subject).to receive(:do_stuff).and_raise(exception)
      end

      it "must print a backtrace and exit with -1" do
        expect {
          expect(subject.run([])).to eq(-1)
        }.to output(
          %r{Oops! Looks like you've found a bug!
Please report the following text to: #{Regexp.escape(described_class::BUG_REPORT_URL)}

```}m
        ).to_stderr
      end
    end
  end
end
