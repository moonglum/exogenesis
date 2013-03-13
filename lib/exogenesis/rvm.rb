require 'exogenesis/abstract_package_manager'

class Rvm < AbstractPackageManager
  def initialize(rubies)
    @rubies = rubies
  end

  def install
    @rubies.each do |ruby|
      print "Installing #{ruby}..."
      status = `rvm install #{ruby} --with-gcc=gcc-4.2`

      if status.include? "Already installed"
        puts "Already Installed!"
      else
        puts "Installed!"
      end
    end
  end

  def update
    puts "Updating RVM"
    `rvm get head`
    `rvm reload`
    @rubies.each do |ruby|
      print "Upgrading #{ruby}..."
      system "rvm upgrade #{ruby}"
    end
  end
end
