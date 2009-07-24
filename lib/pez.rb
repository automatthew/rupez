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
   [:pez_mark, [:pointer], :void],
   [:pez_unwind, [:pointer], :void],
   [:pez_lookup, [:string], :pointer]
  ].each { |fdef|
    attach_function *fdef
  }
  
  class StateMark < FFI::ManagedStruct
    layout  :mstack, :pointer,
            :mheap, :pointer,
            :mrstack, :pointer,
            :mdict, :pointer
    def self.release(ptr)
      ptr.free
    end
  end
  
  class DictWord < FFI::Struct
    layout  :wnext, :pointer,
            :wname, :string,
            :wcode, :pointer
  end
  
  def lookup(word)
    dw = FFI::MemoryPointer.new(DictWord)
    dw = Pez.pez_lookup(word)
    DictWord.new(dw)
  end

  def mark
    mk = FFI::MemoryPointer.new(StateMark)
    Pez.pez_mark(mk)
    FFI::AutoPointer.new(mk.read_pointer, StateMark.method(:release))
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

