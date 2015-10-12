F2C      = f2c
F2CFLAGS = -ARw8 -Nn802 -Nq300 -Nx400 -w
CC       = cc
AR       = ar

PREFIX := $(shell echo $(PREFIX))
CFLAGS := -O3 -fPIC -I$(PREFIX)/include
F2C_LDFLAGS = -L$(PREFIX)/lib -lf2c
LDFLAGS = -lblas -llapack

F_SRC := $(wildcard SRC/*.f) $(wildcard UTIL/*.f)
C_SRC := $(patsubst %.f,%.c,$(F_SRC))
OBJ   := $(patsubst %.f,%.o,$(F_SRC))

%.c : %.f
	(cd $(dir $<) && f2c $(F2CFLAGS) $(notdir $<))

%.o : %.c
	$(CC) $(CFLAGS) -c $< -o $@

libarpack.so: $(OBJ)
	$(CC)  -shared -o $@ $(OBJ) $(F2C_LDFLAGS) $(LDFLAGS)

libarpack.a: $(OBJ)
	$(AR) rcs $@ $(OBJ)
	ranlib $@

clean:
	rm -f UTIL/*.c UTIL/*.o SRC/*.c SRC/*.o
