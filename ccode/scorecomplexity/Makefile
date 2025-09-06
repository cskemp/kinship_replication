CC= gcc

LINKFLAGS = -lm

CFLAGS= -O3 $(LIBFLAGS) -D_GNU_SOURCE

# for debugging with gdb
#CFLAGS= -O0  -g $(LIBFLAGS) 

FINALFLAGS= $(CFLAGS) $(LINKFLAGS)
LDFLAGS= 

LOBJECTS= scorecomplexity.o opt.o parameters.o bheap.o

LSOURCE=  scorecomplexity.c opt.c parameters.c bheap.c

LHEADERS= scorecomplexity.h config.h opt.h parameters.h bheap.h

scorecomplexity:	$(LOBJECTS)
	$(CC) $(FINALFLAGS) $(LOBJECTS) -o scorecomplexity $(LDFLAGS)

tar: 
	tar cvf scorecomplexitylocal.tar Makefile $(LOCAL) 

clean:
	-rm -f *.o

