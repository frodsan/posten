require "ostruct"

class Posten
  def self.sandbox
    return @@sandbox ||= Hash.new { |h, k| h[k] = [] }
  end

  def self.deliveries
    return sandbox[self.name]
  end

  def self.reset
    sandbox.clear
  end

  undef_method(:deliver)

  def deliver(options = {})
    deliveries << OpenStruct.new(defaults.merge(options))
  end

  def deliveries
    return self.class.deliveries
  end
end
