require "pathname"

module RemoteWork
  class PayCommand
    MANAGE_DASHBOARD_PROXY = "manage-dashboard-proxy".freeze
    PAY_COMMAND_ARRAY = %w[pay remote new].freeze
    STRIPE_INTERNAL_BASE = "stripe-internal".freeze
    DEFAULT_ARGS = ["--notify-on-ready", "--skip-confirm", "--ssh", "--open-code"].freeze
    USER = "USER".freeze

    def initialize(args)
      @jira = args.jira
      @title = args.title
      @repo = args.repo
      @ide = args.ide
      @proxy = args.proxy
    end

    def to_s
      cmd_array = ["#{pay_command} \\"]
      dynamic_args.each do |arg|
        cmd_array << "  #{arg} \\"
      end

      DEFAULT_ARGS.each_with_index do |arg, i|
        if i < DEFAULT_ARGS.length - 1
          cmd_array << "  #{arg} \\"
        else
          cmd_array << "  #{arg}"
        end
      end

      cmd_array.join("\n")
    end

    private

    attr_reader :jira, :title, :repo, :ide, :proxy

    def pay_command
      "#{PAY_COMMAND_ARRAY.join(" ")} #{devbox_name}"
    end

    def dynamic_args
      [repo_arg, ide_arg].tap { |a|
        a << service_arg if proxy
      }
    end

    def ide_arg
      "--ide #{ide}"
    end

    def repo_arg
      "--repo #{repo_with_branch}"
    end

    def service_arg
      "--service #{MANAGE_DASHBOARD_PROXY}"
    end

    def repo_with_branch
      [repo_base, branch_name].join(":")
    end

    def repo_base
      Pathname.new(STRIPE_INTERNAL_BASE).join(*[repo]).to_s
    end

    def user
      ENV[USER]
    end

    def branch_name
      [user, jira, title].join("/")
    end

    def devbox_name
      [jira, title].join("-")
    end
  end
end
