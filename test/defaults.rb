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
