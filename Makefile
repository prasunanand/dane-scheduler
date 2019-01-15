# To build dane:
#
#   make
#
# run with
#
#   ./build/dane

D_COMPILER=ldc2

LDMD=ldmd2

DUB_INCLUDE += -I~/.dub/packages/cuda_d-0.1.0/cuda_d/source/ \
               -I/home/prasun/hpc-genomics/OpenMPI/source/

DUB_LIBS    += $(HOME)/.dub/packages/cuda_d-0.1.0/cuda_d/libcuda_d.a \
								/home/prasun/hpc-genomics/OpenMPI/libmpi.a


DFLAGS = -wi -I./source $(DUB_INCLUDE)
RPATH  =
LIBS        += -L=-lmpi -L=-lpthread
SRC    = $(wildcard source/dane/*.d  source/test/*.d)
IR     = $(wildcard source/dane/*.ll source/test/*.ll)
BC     = $(wildcard source/dane/*.bc source/test/*.bc)
OBJ    = $(SRC:.d=.o)
OUT    = build/dane

debug: DFLAGS += -O0 -g -d-debug $(RPATH) -link-debuglib $(BACKEND_FLAG) -unittest
release: DFLAGS += -O -release $(RPATH)

.PHONY:test

all: debug

build-setup:
	mkdir -p build/

build-cuda-setup:
	mkdir -p build/cuda/

ifeq ($(FORCE_DUPLICATE),1)
  DFLAGS += -d-version=FORCE_DUPLICATE
endif


default debug release profile getIR getBC gperf: $(OUT)

# ---- Compile step
%.o: %.d
	$(D_COMPILER) -lib $(DFLAGS) -c $< -od=$(dir $@) $(BACKEND_FLAG)

# ---- Link step
$(OUT): build-setup $(OBJ)
	$(D_COMPILER) -of=build/dane $(DFLAGS)  $(OBJ) $(LIBS) $(DUB_LIBS) $(BACKEND_FLAG)

test:
	chmod 755 build/dane
	./run_tests.sh

debug-strip: debug

clean:
	rm -rf build/*
	rm -f $(OBJ) $(OUT) trace.{def,log}