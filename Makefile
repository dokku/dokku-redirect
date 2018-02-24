shellcheck:
ifeq ($(shell shellcheck > /dev/null 2>&1 ; echo $$?),127)
ifeq ($(shell uname),Darwin)
	brew install shellcheck
else
	sudo add-apt-repository 'deb http://archive.ubuntu.com/ubuntu trusty-backports main restricted universe multiverse'
	sudo apt-get update -qq && sudo apt-get install -qq -y shellcheck
endif
endif

bats:
ifeq ($(shell bats > /dev/null 2>&1 ; echo $$?),127)
ifeq ($(shell uname),Darwin)
	git clone https://github.com/sstephenson/bats.git /tmp/bats
	cd /tmp/bats && sudo ./install.sh /usr/local
	rm -rf /tmp/bats
else
	sudo add-apt-repository ppa:duggan/bats --yes
	sudo apt-get update -qq && sudo apt-get install -qq -y bats
endif
endif

nginx:
ifeq ($(shell nginx > /dev/null 2>&1 ; echo $$?),127)
	sudo apt-get update -qq && sudo apt-get install -qq -y nginx
endif

readlink:
ifeq ($(shell uname),Darwin)
ifeq ($(shell greadlink > /dev/null 2>&1 ; echo $$?),127)
	brew install coreutils
endif
	ln -nfs `which greadlink` tests/bin/readlink
endif

ci-dependencies: shellcheck bats readlink nginx

lint:
	# these are disabled due to their expansive existence in the codebase. we should clean it up though
	# SC1090: Can't follow non-constant source. Use a directive to specify location - https://github.com/koalaman/shellcheck/wiki/SC1090
	# SC2155: Declare and assign separately to avoid masking return values - https://github.com/koalaman/shellcheck/wiki/SC2155
	@echo linting...
	@$(QUIET) find ./ -maxdepth 1 -not -path '*/\.*' | xargs file | egrep "shell|bash" | awk '{ print $$1 }' | sed 's/://g' | xargs shellcheck -e SC1090,SC2155

unit-tests:
	@echo running unit tests...
	@$(QUIET) bats tests

setup:
	bash tests/setup.sh
	$(MAKE) ci-dependencies

test: setup lint unit-tests
