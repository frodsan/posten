require_relative "../lib/posten/test"

Posten.connect({})

Posten.defaults(from: "bob@posten.gem", to: "eve@posten.gem")

setup do
  Posten.reset

  assert_equal 0, Posten.deliveries.size

  { subject: "subject", text: "text", html: "<html></html>" }
end

test "sandbox" do |params|
  posten = Posten.new
  posten.deliver(params)

  mail = Posten.deliveries.first

  assert_equal posten.defaults.merge(params), mail.to_h
end

test "mailer" do |params|
  class UserMailer < Posten
  end

  mailer = UserMailer.new
  mailer.deliver(params)

  mail = UserMailer.deliveries.first

  assert_equal mailer.defaults.merge(params), mail.to_h
end

test "different sandboxes" do |params|
  class UserMailer < Posten
  end

  Posten.new.deliver
  UserMailer.new.deliver

  assert_equal 1, Posten.deliveries.count
  assert_equal 1, UserMailer.deliveries.count
end
