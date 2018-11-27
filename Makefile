# hcs/Makefile

# Don't forget : Makefiles use tabs indentation, not spaces !
.PHONY: test watch

# Aliases to everyday takss faster
t  : test
w  : watch

test: ## Run all tests
	@rake test

watch: ## Run tests when a file changes (like Guard)
	@ls **/*_test.rb | entr rake test
