require 'exogenesis/support/passenger'

# Executes shell scripts
class Shell < Passenger
  register_as :shell
  needs :scripts
  with_emoji :shell

  def up
    scripts.each do |script|
      execute_script(script)
    end
  end

  private

  def execute_script(script)
    execute "Executing #{script}", "#{script}"
  end
end
