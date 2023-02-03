#
# Nix-wrap archive generators (c) Karim Vergnes <me@thesola.io>
# Licensed under GNU GPLv2
#

WORKDIR		:= work

# behold: dogfooding (unsuitable for our CI due to chicken-and-egg)
NIX			:= ./nix
TAR			:= tar
WGET		:= wget

BOOST_VER 		:= 1.81.0
BOOST_ARCHIVE	:= $(WORKDIR)/boost.tar.gz
BOOST_DIR		= boost_$(subst .,_,$(BOOST_VER))

BOOST_ADD_HEADERS = system,thread,context,lexical_cast,format,coroutine2,container,chrono
BOOST_ADD_MODULES = system,thread,context,format,coroutine2,container,chrono

THIS_SYSTEM		= $(shell uname -s)


## Build all downloadable source archives
sources: boost-shaved.tar.gz

## Build all prebuilt Nix binaries (requires Nix)
binaries: nix-static.Linux.x86_64 nix-static.Linux.aarch64 nix-static.Darwin.x86_64 nix-static.Darwin.aarch64


boost-shaved.tar.gz: $(BOOST_ARCHIVE)
	$(TAR) xzf $(BOOST_ARCHIVE) -C $(WORKDIR)
	$(TAR) czf $@ -C $(WORKDIR) \
		$$(cd $(WORKDIR); find $(BOOST_DIR) -maxdepth 1 -type f) \
		$(BOOST_DIR)/boost/{$(BOOST_ADD_HEADERS)}{,.hpp} \
		$(BOOST_DIR)/libs/{$(BOOST_ADD_MODULES),core,config,headers} \
		$(BOOST_DIR)/status \
		$(BOOST_DIR)/tools	; true
	# NOTE: The above command will exit with a nonzero status code due to the
	# headers capture expression matching nonexistent files as well.

$(BOOST_ARCHIVE):
	@mkdir -p $(@D)
	$(WGET) "https://boostorg.jfrog.io/artifactory/main/release/$(BOOST_VER)/source/$(BOOST_DIR).tar.gz" -O $@

include lib.mk
