#!/usr/bin/ruby

require File.expand_path('../../rules/mosync_lib.rb')

mod = Module.new
mod.class_eval do
	if(CONFIG == "" && !GCC_IS_V4)
		# broken compiler
		native_specflags = {"mastdlib.c" => " -Wno-unreachable-code",
		"mastring.c" => " -Wno-unreachable-code"}
	else
		native_specflags = {}
	end
	
	NATIVE_SPECIFIC_CFLAGS = {
		"madmath.c" => " -Wno-missing-declarations",
		"mavsprintf.c" => " -Wno-float-equal"}.merge(native_specflags)
	
	PIPE_SPECIFIC_CFLAGS = NATIVE_SPECIFIC_CFLAGS.merge({
		"maint64.c" => " -fno-strict-aliasing -Wno-missing-declarations",
		"strtod.c" => " -Wno-float-equal",
		"e_log.c" => " -Wno-float-equal",
		"s_atan.c" => " -fno-strict-aliasing",
		"e_atan2.c" => " -fno-strict-aliasing",
		"e_asin.c" => " -fno-strict-aliasing"})
	
	def setup_native
		@SOURCES = []
		@EXTRA_SOURCEFILES = ["conprint.c", "ma.c", "maassert.c", "mactype.c", "madmath.c",
			"mastdlib.c", "mastring.c", "matime.c", "mavsprintf.c", "maxtoa.c", "maheap.c"]
		@SPECIFIC_CFLAGS = NATIVE_SPECIFIC_CFLAGS
		
		@LOCAL_DLLS = ["mosync"]
		setup_base
	end
	
	def setup_pipe
		@SOURCES = [".", "../libsupc++"]
		@IGNORED_FILES = ["new_handler.cc"]
		@SPECIFIC_CFLAGS = PIPE_SPECIFIC_CFLAGS
		
		@EXTRA_OBJECTS = ["crtlib.s"]
		setup_base
	end
	
	def setup_base
		@INSTALL_INCDIR = "."
		@IGNORED_HEADERS = ["math_private.h", "fdlibm.h"]
		@NAME = "mastd"
	end
end

MoSyncLib.invoke(mod)
