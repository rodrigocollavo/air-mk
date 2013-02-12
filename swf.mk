################## SWF Variables
MXMLC = $(FLEX_SDK)/bin/mxmlc
ADL = $(FLEX_SDK)/bin/adl

define swf

$(call chkvars,$1_SOURCES $1_MAIN)

$1_SOURCE_DIRS = $$(filter-out %.swc,$$($1_SOURCES))
$1_SOURCE_SWCS = $$(filter %.swc,$$($1_SOURCES))

$1_SOURCE_FILES = $$(call find,$$($1_SOURCE_DIRS),-name '*.as' -o -name '*.mxml')
$1_CLASSPATH = $$(call find,$$($1_SOURCE_DIRS),-name '*.swc') $$($1_SOURCE_SWCS)

$1_CP = $$(call joinwith,$$(,),$$($1_CLASSPATH))
$1_SP = $$(call joinwith,$$(,),$$($1_SOURCE_DIRS))

$1_CFLAGS = $$($1_FLAGS) \
            $$(if $$($1_CONFIG),-load-config+=$$($1_CONFIG)) \
            $$(if $$($1_SP),-sp+=$$($1_SP)) \
            $$(if $$($1_CP),-l+=$$($1_CP)) \
						-file-specs=$$($1_MAIN) \
            $(if $(DEBUG),-debug) \

$$($1): $$($1_SOURCE_FILES) $$($1_CLASSPATH) $$($1_CONFIG)
	$$(call silent,MXMLC $$@, \
  $$(MXMLC) $$($1_CFLAGS) -o $$@)

ifdef $1_APP_XML
$1_ADL_FLAGS ?= -profile mobileDevice -screensize iPhoneRetina

$4: $$($1_APP_XML) $$($1)
	$$(call silent,ADL $4, \
	$(ADL) $$($1_ADL_FLAGS) $$<)
endif

clean::
	rm -fr $$($1)

endef

$(call suffixrules,SWF,swf)
