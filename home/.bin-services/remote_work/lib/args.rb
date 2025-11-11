require_relative "./two_factor"
require_relative "./subprocess"
require_relative "./title_string"

module RemoteWork
  class Args

    attr_reader :jira, :repo, :ide, :proxy, :run

    def initialize(jira:, title: nil, repo:, ide:, proxy: false, run: false)
      @jira = jira
      @title = title
      @repo = repo
      @ide = ide
      @proxy = proxy
      @run = run
    end

    def title
      @title || default_title
    end

    def self.create(args)
      self.new(**args.map { |k, v| [k.to_sym, v] }.to_h)
    end

    private

    def default_title
      TwoFactor.ensure_2fa_is_ready!
      Subprocess.silent!("jira login")
      jira_command = <<~JIRA_COMMAND
        jira view -t debug '#{jira}' | \
          jq ".fields.summary"
      JIRA_COMMAND
      output = Subprocess.capture!(jira_command).gsub!(/[^0-9A-Za-z ]/, "")
      TitleString.from_str(output).to_s.sub(/^-/, "")
    end
  end
end
