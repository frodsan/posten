require "malone"
require "mote"
require "seteable"
require_relative "posten/version"

class Posten
  include Mote::Helpers
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

  def render(template, params = {})
    return mote(view_path(template), params.merge(app: self), TOPLEVEL_BINDING)
  end

  private def view_path(template)
    return File.join(settings[:views], "#{ template }.mote")
  end
end

Posten.settings[:defaults] = {}
Posten.settings[:views] = File.expand_path("mails", Dir.pwd)
