require 'cli/ui'

module CLI
  module Kit
    autoload :BaseCommand,     'cli/kit/base_command'
    autoload :CommandRegistry, 'cli/kit/command_registry'
    autoload :Config,          'cli/kit/config'
    autoload :EntryPoint,      'cli/kit/entry_point'
    autoload :ReportErrors,    'cli/kit/report_errors'
    autoload :System,          'cli/kit/system'

    class << self
      attr_accessor :failmoji, :emoji
    end
    self.failmoji = "\u{1f469}\u{200d}\u{1f4bb}  "
    self.emoji    = "\u{1f937}  "

    EXIT_FAILURE_BUT_NOT_BUG = 30
    EXIT_BUG                 = 1
    EXIT_SUCCESS             = 0

    # Abort, Bug, AbortSilent, and BugSilent are four ways of immediately bailing
    # on command-line execution when an unrecoverable error occurs.
    #
    # Note that these don't inherit from StandardError, and so are not caught by
    # a bare `rescue => e`.
    #
    # * Abort prints its message in red and exits 1;
    # * Bug additionally submits the exception to Bugsnag;
    # * AbortSilent and BugSilent do the same as above, but do not print
    #     messages before exiting.
    #
    # Treat these like panic() in Go:
    #   * Don't rescue them. Use a different Exception class if you plan to recover;
    #   * Provide a useful message, since it will be presented in brief to the
    #       user, and will be useful for debugging.
    #   * Avoid using it if it does actually make sense to recover from an error.
    #
    # Additionally:
    #   * Do not subclass these.
    #   * Only use AbortSilent or BugSilent if you prefer to print a more
    #       contextualized error than Abort or Bug would present to the user.
    #   * In general, don't attach a message to AbortSilent or BugSilent.
    #   * Never raise GenericAbort directly.
    #   * Think carefully about whether Abort or Bug is more appropriate. Is this
    #       a dev bug? Or is it just user error, transient network failure, etc.?
    #   * One case where it's ok to rescue these outside of Dev::CLI#call or tests:
    #       1. rescue Abort or Bug
    #       2. Print a contextualized error message
    #       3. Re-raise AbortSilent or BugSilent respectively.
    GenericAbort = Class.new(Exception)
    Abort        = Class.new(GenericAbort)
    Bug          = Class.new(GenericAbort)
    BugSilent    = Class.new(GenericAbort)
    AbortSilent  = Class.new(GenericAbort)
  end
end
