require "bundler/setup"
require "cutest"
require_relative "../lib/posten"

require "malone/test"

setup do
  Malone.deliveries.clear

  Posten.connect(url: "smtp://foo%40bar.com:pass1234@smtp.gmail.com:587")
end

test "raise if not smtp settings" do
  Posten.settings.delete(:smtp)

  assert_raise do
    Posten.new
  end
end

test "settings" do
  Posten.settings[:foo] = "foo"

  Notifier = Class.new(Posten)

  assert_equal "foo", Notifier.settings[:foo]

  Notifier.settings[:foo] = "bar"

  assert_equal "foo", Posten.settings[:foo]
  assert_equal "bar", Notifier.settings[:foo]
end

test "defaults" do
  Posten.defaults(from: "bob@posten.gem")

  class EveMailer < Posten
    defaults to: "eve@posten.gem"
  end

  params = { from: "bob@posten.gem" }

  assert_equal params, Posten.settings[:defaults]

  params = params.merge(to: "eve@posten.gem")

  assert_equal params, EveMailer.settings[:defaults]
end

test "deliver use defaults" do
  defaults = { from: "bob@posten.gem", to: "eve@posten.gem" }

  Posten.defaults(defaults)

  params = {
    subject: "subject",
    text: "text",
    html: "<html></html>"
  }

  Posten.new.deliver(params)

  options = Malone.deliveries.last.to_h

  assert_equal options, defaults.merge(params)

  class Mailer < Posten
    defaults to: "alice@posten.gem"
  end

  Mailer.new.deliver(params)

  defaults = defaults.merge(to: "alice@posten.gem")

  options = Malone.deliveries.last.to_h

  assert_equal options, defaults.merge(params)
end

test "testing" do
  require_relative "../lib/posten/test"

  defaults = { from: "bob@posten.gem", to: "eve@posten.gem" }

  Posten.defaults(defaults)

  params = {
    subject: "subject",
    text: "text",
    html: "<html></html>"
  }

  Posten.new.deliver(params)

  mail = Posten.deliveries.first

  assert_equal defaults.merge(params), mail.to_h
end
