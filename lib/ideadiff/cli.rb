require 'ripper'
require 'optparse'

module Ideadiff
  class Cli
    def initialize(args)
      @args = args.dup
      @files = parser.parse(@args.dup)
    end

    # @return [Fixnum] status
    def exec
      return 1 unless $?.success?
      diffs = files.map do |f|
        base_text = show(base, f)
        target_text = show(target, f)
        base_sexp = Ripper.sexp(base_text)
        target_sexp = Ripper.sexp(target_text)
        next nil if base_sexp == target_sexp
        f
      end
      diffs.compact!
      diffs.each { |e| STDERR.puts e }
      diffs.empty? ? 0 : 1
    end

    private

    attr_reader :args, :base, :target, :files

    def show(rev, file)
      `git show #{rev}:#{file}`
    end

    def parser
      @parser ||=
        OptionParser.new do |opt|
          opt.on('--base REV', 'git revision. default: HEAD') { |e| @base = e }
          opt.on('--target REV', 'git revision. default: HEAD') { |e| @target = e }
        end
    end
  end
end
