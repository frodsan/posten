require "ostruct"

class Posten
  def self.deliveries
    return @deliveries ||= []
  end

  def self.reset
    deliveries.clear
  end

  def deliver(options)
    deliveries << OpenStruct.new(defaults.merge(options))
  end

  def deliveries
    return self.class.deliveries
  end
end
