CC=gcc
CFLAGS=-g -Wall -O2 -pthread -march=native

HTSDIR=htslib
INCLUDES=-I$(HTSDIR)
LFLAGS=-L$(HTSDIR)
LIBS=$(HTSDIR)/libhts.a
#LDLIBS=-lm -lz -lpthread # older version of htslib
LDLIBS=-lm -lz -llzma -lbz2 -lpthread

MAIN = eagle
AUX = vector.o util.o calc.o heap.o

all: UTIL HTSLIB READCLASSIFY NOMUTATION
	$(CC) $(CFLAGS) $(LFLAGS) $(INCLUDES) $(MAIN).c -o $(MAIN) $(AUX) $(LIBS) $(LDLIBS)

HTSLIB:
	$(MAKE) -C $(HTSDIR)/

UTIL:
	$(CC) $(CFLAGS) -c vector.c util.c calc.c heap.c $(LDLIBS)

READCLASSIFY:
	$(CC) $(CFLAGS) $(LFLAGS) $(INCLUDES) eagle-rc.c -o eagle-rc $(AUX) $(LIBS) $(LDLIBS)

NOMUTATION:
	$(CC) $(CFLAGS) $(LFLAGS) $(INCLUDES) eagle-nm.c -o eagle-nm $(AUX) $(LIBS) $(LDLIBS)

clean:
	rm -f eagle eagle-rc *.o

# DO NOT DELETE THIS LINE -- make depend needs it
