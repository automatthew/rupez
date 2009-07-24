require 'ffi'

module Pez
  extend FFI::Library

  ffi_lib 'pez'
  
  attach_variable :pez__sp, :pointer
  
  def self.stack
    self.pez__sp
  end
  
  def self.stack=(val)
    self.pez__sp=(val)
  end

  # pez_load takes a C file descriptor
  attach_function :fopen, [ :string, :string ], :pointer

  [
    [:pez_init,    [], :void],
    [:pez_break,   [], :void],
    [:pez_eval,    [:string], :int],
    [:pez_memstat, [], :void],
    [:pez_load,    [:pointer], :int],
    [:pez_mark, [:pointer], :void],
    [:pez_unwind, [:pointer], :void],
    [:pez_lookup, [:string], :pointer],
    [:pez_exec, [:pointer], :int],
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
    dw = Pez.pez_lookup(word.to_s)
    DictWord.new(dw) unless dw.nil?
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
    raise ArgumentError if f.nil?
    pez_load(f)
  end
  
  def word(name, body)
    pez_eval(": #{name} #{body} ;")
  end
  
  def push(val, type=nil)
    if type
      Pez.stack.send("put_#{type}", 0, val)
    else
      case val
      when Integer
        Pez.stack.put_long(0, val)
        Pez.stack += FFI::NativeType::LONG.size
      when Float
        Pez.stack.put_float64(0, val)
        Pez.stack += 8
      end
    end
  end

end

