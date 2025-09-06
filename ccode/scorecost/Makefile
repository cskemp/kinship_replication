CC= gcc

LINKFLAGS = -lm

# for debugging with gdb
#CFLAGS= -O0  -g $(LIBFLAGS) 

CFLAGS= -O3 $(LIBFLAGS) -D_GNU_SOURCE

FINALFLAGS= $(CFLAGS) $(LINKFLAGS)

LDFLAGS= 

LOBJECTS= scorecost.o opt.o parameters.o 

LSOURCE=  scorecost.c opt.c parameters.c 

LHEADERS =  cost.h config.h opt.h parameters.h bheap.h

scorecost:	$(LOBJECTS)
	$(CC) $(FINALFLAGS) $(LOBJECTS) -o scorecost $(LDFLAGS)

tar: 
	tar cvf costlocal.tar Makefile $(LOCAL) 

clean:
	-rm -f *.o

