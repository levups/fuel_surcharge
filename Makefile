# fuel_surchage/Makefile

# Don't forget : Makefiles use tabs indentation, not spaces !
.PHONY: test watch

# Aliases to everyday takss faster
t  : test
w  : watch

test: ## Run all tests
	@bundle exec rake test

watch: ## Run tests when a ruby file changes (like Guard)
	@fd .rb | entr bundle exec rake test
