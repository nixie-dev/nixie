#
# Nix-wrap archive generators (c) Karim Vergnes <me@thesola.io>
# Licensed under GNU GPLv2
#

TAR             := tar
WORKDIR         := work
WGET            := wget

BOOST_VER 		:= 1.81.0
BOOST_ARCHIVE	:= $(WORKDIR)/boost.tar.bz2

BOOST_ADD_HEADERS = core,utility,io,system,thread,context,lexical_cast,config,format,coroutine2,container,chrono,atomic,predef,move,assert,detail,type_traits,intrusive,mpl,date_time,bind,align,preprocessor,ratio,exception,smart_ptr,numeric,functional,container_hash,describe,tuple,iterator,function,integer,type_index,algorithm,range,concept,optional
BOOST_ADD_MODULES = system,thread,context,format,coroutine2,container,chrono,atomic,optional

boost-shaved.tar.gz: $(BOOST_ARCHIVE)
	@mkdir -p $(WORKDIR)
	@$(call rich_echo,"UNTAR","$(BOOST_ARCHIVE)")
	@$(TAR) xjf $(BOOST_ARCHIVE) --strip-components=1 -C $(WORKDIR)
	@$(call rich_echo,"TAR","$@")
	@cd $(WORKDIR) && $(TAR) -czf ../$@ \
		$$(find . -maxdepth 1 -type f) \
		./boost/*.hpp ./boost/*.h \
		./boost/{$(BOOST_ADD_HEADERS)} \
		./libs/{$(BOOST_ADD_MODULES),core,config,headers} \
		./status \
		./tools

$(BOOST_ARCHIVE):
	@mkdir -p $(@D)
	@$(call rich_echo,"WGET","$@")
	@$(WGET) "https://boostorg.jfrog.io/artifactory/main/release/$(BOOST_VER)/source/..tar.gz" -O $@

## Remove generated files
clean:
	@$(call rich_echo,"RM","$(WORKDIR)")
	@rm -rf $(WORKDIR)

include ./lib.mk
