default: test

install:
	@cat .gems | xargs gem install

smtp:
	mt 2525

test:
	@cutest -r ./test/helper.rb ./test/*.rb

.PHONY: test
