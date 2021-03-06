require 'spec_helper'

describe Fudge::Tasks::Shell do
  describe :run do
    it "should take a command and run it" do
      described_class.new(:ls).should run_command 'ls'
    end

    it "should add any arguments given" do
      described_class.new(:ls, '-l', '-a').should run_command 'ls -l -a'
    end

    it "should return false for an unsuccessful command" do
      described_class.new(:ls, '--newnre').run.should be_false
    end

    it "should return true for a successful command" do
      described_class.new(:ls).run.should be_true
    end
  end

  describe :check_for do
    context "with no callable to check the matches" do
      subject { described_class.new(:ls, :check_for => /4 files found/) }

      it { should succeed_with_output "Hello there were 4 files found." }
      it { should_not succeed_with_output "Hellow there were 5 files found." }
    end

    context "with a callable to check the matches" do
      subject { described_class.new(:ls, :check_for => [/(\d+) files found/, lambda { |matches| matches[1].to_i >= 4 }]) }

      it { should_not succeed_with_output "Hello there were 3 files found." }
      it { should succeed_with_output "Hello there were 4 files found." }
      it { should succeed_with_output "Hellow there were 5 files found." }
    end
  end
end
