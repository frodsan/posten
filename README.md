posten
======

Mail delivery.

Usage
-----

Configure the client with your SMTP credentials:

```ruby
require "posten"

Posten.connect(
  host: "smtp.posten.gem",
  port: "587",
  user: "eve@posten.gem",
  password: "secret"
)

# or:

Posten.connect(url: "smtp://eve%40posten.gem:secret@smtp.posten.gem:587")
```

Use the `deliver` method to send mails:

```ruby
posten = Posten.new

posten.deliver(
  from: "bob@posten.gem",
  to: "alice@posten.gem",
  subject: "Hei",
  text: "hvordan går det?",
  html: "<b>hvordan går det?</b>"
)
```

Check [SMTP settings](#smtp-settings) and [Delivery Options](#delivery-options)
for more supported options.

Defaults
--------

You can use the `defaults` method to set default values for
the `deliver` method options.

```ruby
Posten.defaults(
  from: "no-reply@posten.gem",
  cc: "jameson@posten.gem"
)

posten = Posten.new

posten.deliver(to: "alice@posten.gem", subject: "hei")
# from: no-reply@posten.gem
# to: alice@posten.gem
# cc: jameson@posten.gem
# subject: =?utf-8?Q?hei?=
```

Mailers
-------

You can use inheritance to create mailer classes:

```ruby
class UserMailer < Posten
  defaults from: "admin@posten.gem"

  def welcome_mail(user)
    deliver(
      to: user.email,
      subject: "Welcome #{ user.name }!",
      text: "You have successfully signed up."
    )
  end
end

mailer = UserMailer.new
mailer.welcome_mail(User.first)
```

Defaults are inherited but can be changed through the `defaults` method.

Testing
-------

If you don't want to call the actual delivery method in your tests, you
can use `posten/test`:

```ruby
require "posten/test"

posten = Posten.new
posten.deliver(to: "alice@posten.gem", subject: "hei")

Posten.deliveries.count # => 1

mail = Posten.deliveries.first
mail.to == "alice@posten.gem" # => true
mail.subject == "hei"         # => true

mailer = UserMailer.new
mailer.welcome_mail(User.first)

UserMailer.deliveries.count # => 1
```

`Posten.deliveries` is simply an array. If you want to have a clean slate,
you can reset it manually using Array's `clear` method before each test is
executed. The next example uses the testing library [Cutest][cutest]:

```ruby
require "cutest"
require "posten/test"

setup do
  Posten.deliveries.clear
end

scope "signup" do
  test "welcome" do
    post "/signup", email: "bob@posten.gem", name: "bob"

    assert_equal 1, UserMailer.deliveries.count

    mail = UserMailer.deliveries.first

    assert_equal "bob@posten.gem", mail.to
    assert /Welcome bob!/ === mail.text
  end
end
```

SMTP Settings
-------------

This is a list of supported STMP settings:

| Option      | Description                      | Default |
| ----------- | -------------------------------- | ------- |
| `:url`      | URL connection                   | `nil`   |
| `:host`     | hostname or IP address           | `nil`   |
| `:port`     | port to connect                  | `25`    |
| `:user`     | user for SMTP authentication     | `nil`   |
| `:password` | password for SMTP authentication | `nil`   |
| `:domain`   | HELO domain                      | `nil`   |
| `:auth`     | type of authentication           | `nil`   |
| `:tls`      | enables SMTP/TLS                 | `true`  |

Delivery Options
----------------

This is a list of supported delivery options:

```ruby
posten = Posten.new

posten.deliver(
  from: "bob@posten.gem",
  to: "alice@posten.gem",
  subject: "Here are some files for you!",
  text: "This is what people with plain text mail readers will see",
  html: "A little something <b>special</b> for people with HTML readers",
  cc: "carboncopy@posten.gem",
  bcc: "blindcarboncopy@posten.gem",
  attach: "/path/to/your/file.pdf",
  attach_as: ["/path/to/your/file.pdf", "new_name.pdf"]
)
```

Installation
------------

```
$ gem install posten
```

[cutest]: https://github.com/djanowski/cutest
