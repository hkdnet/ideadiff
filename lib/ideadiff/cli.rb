module Ideadiff
  class Cli
    def initialize(args)
      @args = args
    end

    # @return [Fixnum] status
    def exec
      text = show('HEAD~', 'Gemfile')
      return 1 unless $?.success?
      puts text
      0
    end

    def show(rev, file)
      `git show #{rev}:#{file}`
    end
  end
end
