FC := gfortran
CC := cc

FFLAGS  := -O3 -fPIC
LDFLAGS := -lblas -llapack -lm -static-libgcc $(shell $(FC) -print-file-name=libgfortran.a) $(shell $(FC) -print-file-name=libquadmath.a)
F_SRC   := $(wildcard SRC/*.f) $(wildcard UTIL/*.f)
OBJ     := $(patsubst %.f,%.o,$(F_SRC))

%.o : %.f
	$(FC) $(FFLAGS) -c $< -o $@

libarpack.so: $(OBJ)
	$(CC)  -shared -o $@ $(OBJ) $(LDFLAGS)

clean:
	rm -f UTIL/*.c UTIL/*.o SRC/*.c SRC/*.o
