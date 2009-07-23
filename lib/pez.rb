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
   [:pez_mark, [:pointer], :void],
   [:pez_unwind, [:pointer], :void],
	].each { |fdef|
		attach_function *fdef
	}
	
  class StateMark < FFI::Struct
    layout  :mstack, :pointer,
            :mheap, :pointer,
            :mrstack, :pointer,
            :mdict, :pointer
  end
  
  def mark
    mk = StateMark.new
    Pez.pez_mark(mk)
    mk
  end
  
  def unwind(mark)
    Pez.pez_unwind(mark)
  end
	
	def load(file)
	  f = fopen(file, "r")
	  raise ArgumentError if f == FFI::NullPointer.new
    pez_load(f)
	end
	
end