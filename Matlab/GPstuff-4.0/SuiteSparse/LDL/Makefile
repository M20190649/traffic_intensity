#------------------------------------------------------------------------------
# LDL Makefile
#------------------------------------------------------------------------------

default: demo

include ../UFconfig/UFconfig.mk

# Compile all C code, including the C-callable routine.
demo:
	( cd Lib    ; $(MAKE) )
	( cd Demo   ; $(MAKE) )

# Compile all C code, including the C-callable routine and the mexFunctions.
all:
	( cd Lib    ; $(MAKE) )
	( cd Demo   ; $(MAKE) )
	( cd MATLAB ; $(MAKE) )

# compile just the C-callable libraries (not mexFunctions or Demos)
library:
	( cd Lib    ; $(MAKE) )

# remove object files, but keep the compiled programs and library archives
clean:
	( cd Lib    ; $(MAKE) clean )
	( cd Demo   ; $(MAKE) clean )
	( cd MATLAB ; $(MAKE) clean )
	( cd Doc    ; $(MAKE) clean )

# clean, and then remove compiled programs and library archives
purge:
	( cd Lib    ; $(MAKE) purge )
	( cd Demo   ; $(MAKE) purge )
	( cd MATLAB ; $(MAKE) purge )
	( cd Doc    ; $(MAKE) purge )

distclean: purge

# create PDF documents for the original distribution
doc:
	( cd Doc    ; $(MAKE) )

# get ready for distribution
dist: purge
	( cd Demo   ; $(MAKE) dist )
	( cd Doc    ; $(MAKE) )

ccode: library

lib: library

# compile the MATLAB mexFunction
mex:
	( cd MATLAB ; $(MAKE) )
