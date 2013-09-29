require "ostruct"

class Ship
  PASSENGER_TYPES = {
    "dotfile" => Dotfile,
    "fonts" => Fonts,
    "git_repo" => GitRepo,
    "homebrew" => Homebrew,
    "oh_my_zsh" => OhMyZSH,
    "python" => Python,
    "rvm" => Rvm,
    "vundle" => Vundle
  }

  def initialize(raw_config)
    config = OpenStruct.new(raw_config)
    @package_managers = []
    config.passengers.each do |passenger_name|
      @package_managers << PASSENGER_TYPES.fetch(passenger_name).new(config)
    end
  end

  def setup
    @package_managers.each(&:setup)
  end

  def install
    @package_managers.each(&:install)
  end

  def cleanup
    @package_managers.each(&:cleanup)
  end

  def update
    @package_managers.each(&:update)
  end

  def teardown
    @package_managers.each(&:teardown)
  end
end
