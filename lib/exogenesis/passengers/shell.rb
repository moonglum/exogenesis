require 'exogenesis/support/passenger'

# Executes shell commands
class Shell < Passenger
  register_as :shell
  needs :commands
  with_emoji :shell

  def up
    commands.each do |command|
      execute_command(command)
    end
  end

  private

  def execute_command(command)
    execute "Executing command `#{command}`", "#{command}"
  end
end
