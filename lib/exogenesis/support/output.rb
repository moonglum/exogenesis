require "singleton"

# Output is a Singleton. Get the instance
# via `Output.instance`
class Output
  include Singleton

  def initialize
    @verbose = false
    @center = false
    @decoration = false
    @success = "Success"
    @failure = "Failure"
    @skip = "Skipped"
    @header_start = ""
    @header_end = ""
  end

  # Activates fancy output by activating all other
  # options except verbose.
  def fancy
    self.activate_centering.activate_decoration.activate_utf8
  end

  # Activates fancy output by activating all other
  # options except verbose.
  def self.fancy
    self.instance.fancy
  end

  # Activates the centering of output
  def activate_centering
    @center = true
    self
  end

  # Activates the centering of output
  def self.activate_centering
    self.instance.activate_centering
  end

  # Activates bold and colored output
  def activate_decoration
    @decoration = true
    self
  end

  # Activates bold and colored output
  def self.activate_decoration
    self.instance.decoration
  end

  # Output the additional information for
  # the success method
  def verbose
    @verbose = false
    self
  end

  # Output the additional information for
  # the success method
  def self.verbose
    self.instance.verbose
  end

  # Activate the usage of 'UTF8 Icons'
  def activate_utf8
    @success = "\u2713"
    @failure = "\u2717"
    @skip = "\u219D"
    @header_start = "\u2605  "
    @header_end = " \u2605"
    @border = {
      :top_left => "\u250C",
      :top_center => "\u2500",
      :top_right => "\u2510",
      :bottom_left => "\u2514",
      :bottom_center => "\u2500",
      :bottom_right => "\u2518",
    }
    self
  end

  # Activate the usage of 'UTF8 Icons'
  def self.activate_utf8
    self.instance.activate_utf8
  end

  # Print the text as a decorated header
  def decorated_header(text)
    puts
    puts bold(center("#{@header_start}#{text}#{@header_end}"))
  end

  # Print the left side of an output
  def left(text)
    print left_aligned("#{text}:")
  end

  # Print the right side with a success message
  # If verbose is active, the further_information
  # will be printed
  def success(further_information)
    puts green_bold(" #{@success}")
    puts further_information if @verbose and further_information != ""
  end

  # Print the right side with a failure message
  # Will always print the further_information
  def failure(further_information)
    puts red_bold(" #{@failure}")
    puts further_information
  end

  # Print the right side with a skipped message
  # If verbose is active, the further_information
  # will be printed
  def skipped(further_information)
    puts green_bold(" #{@skip}")
    puts further_information if @verbose and further_information != ""
  end

  # Print some arbitrary information on the right
  def info(information)
    puts " #{information}"
  end

  # Draw the upper bound of a border
  def start_border(header)
    header = " #{header} "
    puts @border[:top_left] +
      header.center((terminal_width - 2), @border[:top_center]) +
      @border[:top_right]
  end

  # Draw the lower bound of a border
  def end_border
    puts @border[:bottom_left] +
      (@border[:bottom_center] * (terminal_width - 2)) +
      @border[:bottom_right]
  end

private

  # Determine the width of the terminal
  def terminal_width
    Integer(`tput cols`)
  end

  # Return the text as bold if and only if decoration
  # is active
  def bold(text)
    @decoration ? "\033[1m#{text}\033[0m" : text
  end

  # Return the text as centered if and only if center
  # is active
  def center(text)
    @center ? text.center(terminal_width) : text
  end

  # Return the text as left aligned if and only if center
  # is active
  def left_aligned(text)
    @center ? text.rjust(terminal_width / 2) : text
  end

  # Return the text as green bold if and only if decoration
  # is active
  def green_bold(text)
    @decoration ? "\033[1;32m#{text}\033[0m" : text
  end

  # Return the text as red bold if and only if decoration
  # is active
  def red_bold(text)
    @decoration ? "\033[1;31m#{text}\033[0m" : text
  end
end
