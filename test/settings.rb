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
