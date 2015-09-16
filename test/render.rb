Posten.settings[:views] = File.expand_path("mails", __dir__)

setup do
  Posten.connect({})
  Posten.new
end

test "render" do |posten|
  content = posten.render("mail", message: "posten")

  assert_equal "posten", content.strip
end
