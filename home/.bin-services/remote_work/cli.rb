require "thor"

require_relative "./lib/pay_command"
require_relative "./lib/args"

module RemoteWork
  class CLI < Thor
    desc "", "print a command to start a remote devbox"
    option :jira, type: :string, desc: "JIRA ticket", required: true, aliases: :j
    option :title, type: :string, desc: "pr and devbox title", required: false, aliases: :t
    option :repo, type: :string, desc: "repo", default: "pay-server", aliases: :r, required: false
    option :ide, type: :string, desc: "ide", default: "vscode", aliases: :i, required: false
    option :stack, type: :boolean, desc: "create as stack", default: false, aliases: :s, required: false
    option :proxy, type: :boolean, desc: "start a proxy", default: false, aliases: :p, required: false

    default_command :execute

    def execute
      args = Args.create(options)
      puts(PayCommand.new(args).to_s)
    end
  end
end
