require 'ffi'

module Pez
	extend FFI::Library

	ffi_lib 'pez'
  
  # pez_load takes a C file descriptor
  attach_function :fopen, [ :string, :string ], :pointer

	[[:pez_init,    [], :void],
	 [:pez_break,   [], :void],
	 [:pez_eval,    [:string], :int],
	 [:pez_memstat, [], :void],
   [:pez_load,    [:pointer], :int],
	 # These don't quite work well with FFI (or with 0.2 at least; maybe fixed):
	 # [:pez_mark, [:pointer], :void],
	 # [:pez_unwind, [:pointer], :void],
	].each { |fdef|
		attach_function *fdef
	}
	
	def load(file)
	  f = fopen(file, "r")
	  raise ArgumentError if f == FFI::NullPointer.new
    pez_load(f)
	end
	
end