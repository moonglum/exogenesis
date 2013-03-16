class TaskSkipped < RuntimeError
  def initialize(additional_information)
    @additional_information = additional_information
  end

  def to_s
    @additional_information
  end
end
