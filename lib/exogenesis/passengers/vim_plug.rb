require 'exogenesis/support/passenger'

class VimPlug < Passenger
  register_as :vim_plug
  with_emoji :gift

  def up
    execute_interactive 'Installing and Updating Vim plugins', 'vim +PlugUpdate\! +qall'
  end

  def down
  end

  def clean
    execute_interactive 'Cleaning', 'vim +PlugClean\! +qall'
  end
end
