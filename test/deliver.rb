require "malone/test"

setup do
  Malone.deliveries.clear

  Posten.connect(url: "smtp://foo%40bar.com:pass1234@smtp.gmail.com:587")
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
