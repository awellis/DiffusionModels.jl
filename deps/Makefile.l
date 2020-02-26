CC=g++ #clang++
CCFLAGS=-std=c++11 -Wall 
OBJS=test_ddm_fpt_lib.o ddm_fpt_lib.o
# LIB_CCFLAGS=-std=c++11 -Wall -O3 -g -shared -fPIC -O1 -g -fsanitize=address -fsanitize=leak -fno-omit-frame-pointer -lasan
LIB_CCFLAGS=-std=c++11 -Wall -O3 -g -shared -fPIC 

default: all
all: ddm_fpt_lib.so
clean: clean_ddm_fpt_lib clean_test_ddm_fpt_lib *.o *.so
.PHONY: clean

t1: t1.c ddm_fpt_lib.so
	$(CC) $(CCFLAGS) -o $@ t1.c ddm_fpt_lib.so

ddm_fpt_lib.o: ddm_fpt_lib.cpp ddm_fpt_lib.h
	$(CC) $(CCFLAGS) -c ddm_fpt_lib.cpp -o $@

ddm_fpt_lib.so: ddm_fpt_lib.cpp carlo.cpp
	$(CC) $(LIB_CCFLAGS) -o $@ ddm_fpt_lib.cpp carlo.cpp -Lm

test_ddm_fpt_lib.o: test_ddm_fpt_lib.cpp ddm_fpt_lib.h
	$(CC) $(CCFLAGS) -c test_ddm_fpt_lib.cpp -o $@

test_ddm_fpt_lib: test_ddm_fpt_lib.o ddm_fpt_lib.o
	$(CC) $(CCFLAGS) test_ddm_fpt_lib.o ddm_fpt_lib.o -o $@

clean_ddm_fpt_lib:
	rm -rf ddm_fpt_lib.o

clean_test_ddm_fpt_lib:
	rm -rf test_ddm_fpt_lib.o
