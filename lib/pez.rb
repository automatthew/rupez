require 'ffi'

module Pez
  extend FFI::Library

  ffi_lib 'pez'
  
  # You can adjust the size of the stack, return stack, heap, and initial 
  # dictionary allocated by Pez by setting the following variables before
  # calling pez_init.
  attach_variable :pez__sp, :pointer
  attach_variable :pez_stklen, :long
  attach_variable :pez_rstklen, :long
  attach_variable :pez_heaplen, :long
  attach_variable :pez_ltempstr, :long
  attach_variable :pez_ntempstr, :long
  
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
    increment = case val
    when String
      pez_eval val.dump
    when Array
      case val.first
      when Integer
        Pez.stack.write_array_of_long(val)
        FFI::NativeType::LONG.size * val.size
      when Float
        Pez.stack.put_array_of_float64(0, val)
        8 * val.size
      end
    when Integer
      Pez.stack.put_long(0, val)
      FFI::NativeType::LONG.size
    when Float
      Pez.stack.put_float64(0, val)
      8
    end
    Pez.stack += increment
  end

end

