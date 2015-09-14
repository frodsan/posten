require "malone"
require "seteable"
require_relative "posten/version"

class Posten
  include Seteable

  def self.connect(options)
    settings[:smtp] = options
  end

  def self.defaults(defaults)
    settings[:defaults].update(defaults)
  end

  def initialize
    @malone = Malone.new(config)
  end

  private def config
    return Malone::Configuration.new(smtp_settings)
  end

  private def smtp_settings
    settings[:smtp] or raise("Missing configuration: Try `Posten.connect`")
  end

  def deliver(options)
    return @malone.deliver(defaults.merge(options))
  end

  def defaults
    return settings[:defaults]
  end
end

Posten.settings[:defaults] = {}
