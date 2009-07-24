module Pez

  # pez_eval return status codes

  SNORM = 0            # Normal evaluation
  STACKOVER  = -1      # Stack overflow
  STACKUNDER = -2      # Stack underflow
  RSTACKOVER = -3      # Return stack overflow
  RSTACKUNDER = -4     # Return stack underflow
  HEAPOVER = -5        # Heap overflow
  BADPOINTER = -6      # Pointer outside the heap
  UNDEFINED = -7       # Undefined word
  FORGETPROT = -8      # Attempt to forget protected word
  NOTINDEF = -9        # Compiler word outside definition
  RUNSTRING = -10      # Unterminated string
  RUNCOMM = -11        # Unterminated comment in file
  BREAK = -12          # Asynchronous break signal received
  DIVZERO = -13        # Attempt to divide by zero
  APPLICATION = -14    # Application primitive pez_error()
  
end