#!/usr/bin/env ruby
require 'rubygems'
require 'pez'
require 'pp'

if __FILE__ == $0
  include Pez
  pez_init
  
  m = mark
  
  # pez_eval ": foo 5 3 + . cr ;"
  # 
  # foo = lookup("foo")
  # pez_exec(foo)
  
  word :square, "dup * . cr"
  push 15
  square = lookup(:square)
  pez_exec(square)
  
  
  word :fsquare, "fdup f* f. cr"
  push 1.5
  fsquare = lookup(:fsquare)
  pez_exec(fsquare)
  
  unwind(m)
  
  # loop {
  #   print "-> " if $stdin.tty?
  #   $stdout.flush
  #   pez_eval(gets || break)
  # }
  
end

puts
