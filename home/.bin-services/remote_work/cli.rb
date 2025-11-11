require "thor"

require_relative "./lib/pay_command"
require_relative "./lib/args"
require_relative "./lib/subprocess"

module RemoteWork
  class CLI < Thor
    check_unknown_options!

    desc "help", "", hidden: true
    desc "execute", "print a command to start a remote devbox", hidden: true
    class_option :jira, type: :string, desc: "JIRA ticket", required: true, aliases: :j
    class_option :title, type: :string, desc: "pr and devbox title", required: false, aliases: :t
    class_option :repo, type: :string, desc: "repo", default: "pay-server", aliases: :r, required: false
    class_option :ide, type: :string, desc: "ide", default: "vscode", aliases: :i, required: false
    class_option :proxy, type: :boolean, desc: "start a proxy", default: false, aliases: :p, required: false
    class_option :run, type: :boolean, desc: "run the command", default: false, aliases: :e, required: false

    default_command :execute
    def execute
      args = Args.create(options)
      pay_command = PayCommand.new(args).to_s
      if args.run
        Subprocess.inline!(pay_command)
      else
        puts(pay_command)
      end
    end
  end
end
