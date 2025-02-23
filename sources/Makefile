#
# Nixie archive generators (c) Karim Vergnes <me@thesola.io>
# Licensed under GNU GPLv2
#

TAR             := tar
WORKDIR         := work
WGET            := wget

BOOST_VER 		:= 1.87.0
BOOST_ARCHIVE	:= $(WORKDIR)/boost.tar.bz2

BOOST_ADD_HEADERS = core,utility,io,system,thread,context,lexical_cast,config,format,coroutine2,container,chrono,atomic,predef,move,assert,detail,type_traits,intrusive,mpl,date_time,bind,align,preprocessor,ratio,exception,smart_ptr,numeric,functional,container_hash,describe,tuple,iterator,function,integer,type_index,algorithm,range,concept,optional,mp11
BOOST_ADD_MODULES = system,thread,context,format,coroutine2,container,chrono,atomic,optional

boost-shaved.tar.gz: $(BOOST_ARCHIVE)
	@mkdir -p $(WORKDIR)
	@$(call rich_echo,"UNTAR","$(BOOST_ARCHIVE)")
	@$(TAR) xjf $(BOOST_ARCHIVE) --transform "s,^boost_[0-9_]*/,boost/," -C $(WORKDIR)
	@$(call rich_echo,"TAR","$@")
	@cd $(WORKDIR) && $(TAR) -czf ../$@ \
		$$(find boost -maxdepth 1 -type f) \
		boost/boost/*.hpp boost/boost/*.h \
		boost/boost/{$(BOOST_ADD_HEADERS)} \
		boost/libs/{$(BOOST_ADD_MODULES),core,config,headers} \
		boost/status \
		boost/tools

$(BOOST_ARCHIVE):
	@mkdir -p $(@D)
	@$(call rich_echo,"WGET","$@")
	@$(WGET) "https://boostorg.jfrog.io/artifactory/main/release/$(BOOST_VER)/source/boost_$(subst .,_,$(BOOST_VER)).tar.bz2" -O $@

## Remove generated files
clean:
	@$(call rich_echo,"RM","$(WORKDIR)")
	@rm -rf $(WORKDIR)

include ./lib.mk
