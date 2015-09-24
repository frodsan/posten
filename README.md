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
  defaults from: "team@posten.gem"

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

Templates
---------

You can render templates using the `render` method. It uses the template
engine [Mote][mote].

```ruby
class UserMailer < Posten
  defaults from: "team@posten.gem"

  def welcome_email(user)
    deliver(
      to: user.email,
      subject: "Welcome #{ user.name }!",
      text: render("welcome.txt", user: user),
      html: render("welcome.html", user: user)
    )
  end
end
```

By default, it assumes that all mail templates are placed in a folder named
`mails` and that they use the `.mote` extension:

```
# mails/welcome.txt.mote
Welcome {{ user.name }}!

# mails/welcome.html.mote
<b>Welcome {{ user.name }}!</b>
```

Check [Mote's GitHub repository][mote] for more information.

Helpers
-------

Included helper modules are available inside the template through the `app`
variable.

```ruby
module TextHelper
  def titleize(str)
    return str.gsub(/\w+/) { |x| x.capitalize }
  end
end

class UserMailer < Posten
  include TextHelper

  defaults from: "team@posten.gem"

  # ...
end

# mails/welcome.txt.mote
welcome {{ app.titleize(user.name) }}!
```

Development
-----------

You can use [mt][mt] to fake a SMTP server and print mails to STDOUT.

```
$ gem install mt
$ mt 2525
```

Update the smtp settings with the fake SMTP server url. It's recommended
to store configuration in environment variables.

```ruby
# SMTP_URL => "smtp://localhost:2525"
Posten.connect(url: ENV.fetch("SMTP_URL"))
```

Enjoy:

```
$ mt 2525
---
from: bob@posten.gem
to: alice@posten.gem
Reply-To:
subject: =?utf-8?Q?hello?=
Message-ID: <1442511985.7632298.501.70146383400960@me.com>
Date: Thu, 17 Sep 2015 19:46:25 +0200

Can you keep a secret?
```

Testing
-------

If you don't want to call the actual delivery method in your tests, you
can use `posten/test`:

```ruby
require "posten"
require "posten/test"

Posten.connect({ ... })

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

Use `Posten.reset` to have a clean slate before each test is executed:

```ruby
require "cutest"
require "posten/test"

prepare do
  Posten.reset
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

The example above uses the testing library [Cutest][cutest].

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
[mote]: https://github.com/soveran/mote
[mt]: https://github.com/soveran/mt
