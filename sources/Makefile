#
# Nix-wrap archive generators (c) Karim Vergnes <me@thesola.io>
# Licensed under GNU GPLv2
#

TAR             := tar
WORKDIR         := work

BOOST_VER 		:= 1.81.0
BOOST_ARCHIVE	:= $(WORKDIR)/boost.tar.bz2
BOOST_DIR		= boost_$(subst .,_,$(BOOST_VER))

BOOST_ADD_HEADERS = core,utility,io,system,thread,context,lexical_cast,config,format,coroutine2,container,chrono,atomic,predef,move,assert,detail,type_traits,intrusive,mpl,date_time,bind,align,preprocessor,ratio,exception,smart_ptr,numeric,functional,container_hash,describe,tuple,iterator,function,integer,type_index,algorithm,range,concept,optional
BOOST_ADD_MODULES = system,thread,context,format,coroutine2,container,chrono,atomic,optional

boost-shaved.tar.gz: $(BOOST_ARCHIVE)
	@mkdir -p $(WORKDIR)
	@$(call rich_echo,"UNTAR","$(BOOST_ARCHIVE)")
	@$(TAR) xjf $(BOOST_ARCHIVE) -C $(WORKDIR)
	@$(call rich_echo,"TAR","$@")
	@cd $(WORKDIR) && $(TAR) czf ../$@ \
		$$(find $(BOOST_DIR) -maxdepth 1 -type f) \
		$(BOOST_DIR)/boost/*.hpp $(BOOST_DIR)/boost/*.h \
		$(BOOST_DIR)/boost/{$(BOOST_ADD_HEADERS)} \
		$(BOOST_DIR)/libs/{$(BOOST_ADD_MODULES),core,config,headers} \
		$(BOOST_DIR)/status \
		$(BOOST_DIR)/tools

$(BOOST_ARCHIVE):
	@mkdir -p $(@D)
	@$(call rich_echo,"WGET","$@")
	@$(WGET) "https://boostorg.jfrog.io/artifactory/main/release/$(BOOST_VER)/source/$(BOOST_DIR).tar.gz" -O $@

## Remove generated files
clean:
	@$(call rich_echo,"RM","$(WORKDIR)")
	@rm -rf $(WORKDIR)

include ./lib.mk
