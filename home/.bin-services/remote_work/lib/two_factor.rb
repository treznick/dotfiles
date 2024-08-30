require_relative "./subprocess"
require_relative "./formatting"

module RemoteWork
  module TwoFactor
    extend Formatting
    def self.ensure_2fa_is_ready!
      return if Subprocess.success?("sc-2fa info")

      puts(
        <<~MSG

          #{warning("WARN:")} You need to refresh your #{entity("sc-2fa")} token:

        MSG
      )

      Subprocess.inline!("sc-2fa")

      puts
    end
  end
end
