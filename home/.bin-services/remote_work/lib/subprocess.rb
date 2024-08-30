require "open3"

class Subprocess
  def self.success?(cmd, cwd: ".")
    _, _, status = Open3.capture3(cmd, chdir: cwd)
    status.success?
  end

  def self.capture!(cmd, cwd: ".", stdin: nil)
    output, error, status = Open3.capture3(cmd, chdir: cwd, stdin_data: stdin)
    check_error!(status, error, cmd)

    output.strip
  end

  def self.capture(cmd, cwd: ".", stdin: nil)
    output, error, status = Open3.capture3(cmd, chdir: cwd, stdin_data: stdin)

    # TODO: did error.strip break stuff
    status.success? ? output.strip : error.strip
  end

  def self.silent!(cmd, cwd: ".")
    _, error, status = Open3.capture3(cmd, chdir: cwd)
    check_error!(status, error, cmd)

    nil
  end

  def self.silent(cmd, cwd: ".")
    _, _, status = Open3.capture3(cmd, chdir: cwd)

    status
  end

  def self.inline!(cmd, cwd: ".")
    Open3.popen2e(cmd, chdir: cwd) do |_, stream|
      while line = stream.gets
        puts("    #{line}")
      end
    end
  end

  class SubprocessError < StandardError
  end

  def self.check_error!(status, error, cmd)
    unless status.success?
      raise(
        SubprocessError,
        <<~CMD
          Error running command: #{cmd.inspect}

          #{error}
        CMD
      )
    end
  end
end
