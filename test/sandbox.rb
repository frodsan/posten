require_relative "../lib/posten/test"

test "sandbox" do
  Posten.connect({})

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
