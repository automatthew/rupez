#!/usr/bin/env ruby
require 'rubygems'
require 'pez'
require 'pp'

if __FILE__ == $0
  include Pez
  pez_init
  
  murray do
  
    word :square, "dup * . cr"
    push 15
    square = lookup(:square)
    pez_exec(square)
  
  
    word :fsquare, "fdup f* f. cr"
    push 1.5
    fsquare = lookup(:fsquare)
    pez_exec(fsquare)
    
    push [ 2.0, 3.0 ]
    pez_eval "f- f. cr"
  
    push "monkey"
    pez_eval "puts"
  
  end
  
  # loop {
  #   print "-> " if $stdin.tty?
  #   $stdout.flush
  #   pez_eval(gets || break)
  # }
  
end

puts
