################################################################################
# Variables
################################################################################

VERSION=0.3.0
PREFIX=/usr/local
DESTDIR=
BINDIR=${PREFIX}/bin
DATADIR=${PREFIX}/share
INCLUDEDIR=${PREFIX}/include
LIBDIR=${PREFIX}/lib

SKYD_SRCS = $(wildcard skyd/*.go)

BINARIES = skyd
BUILDDIR = build

all: $(BINARIES)

$(BUILDDIR)/%:
	mkdir -p $(dir $@)
	cd $* && go build -o $(abspath $@)

$(BINARIES): %: $(BUILDDIR)/%


################################################################################
# Dependencies
################################################################################

leveldb:
	${MAKE} clean -C deps/leveldb-1.9.0
	${MAKE} -C deps/leveldb-1.9.0
	install -m 755 -d ${DESTDIR}${INCLUDEDIR}/leveldb
	install -m 755 deps/leveldb-1.9.0/include/leveldb/* ${DESTDIR}${INCLUDEDIR}/leveldb
	install -m 755 -d ${DESTDIR}${LIBDIR}
	install -m 755 deps/leveldb-1.9.0/libleveldb* ${DESTDIR}${LIBDIR}

luajit:
	${MAKE} -C deps/LuaJIT-2.0.1 clean PREFIX=${PREFIX}
	${MAKE} -C deps/LuaJIT-2.0.1 PREFIX=${PREFIX}
	${MAKE} -C deps/LuaJIT-2.0.1 install PREFIX=${PREFIX}

csky:
	${MAKE} -C csky clean install PREFIX=${PREFIX}

deps: leveldb luajit csky


################################################################################
# Build
################################################################################

$(BUILDDIR)/skyd: $(SKYD_SRCS)


################################################################################
# Clean
################################################################################

clean:
	rm -fr $(BUILDDIR)

# Targets
.PHONY: install clean all csky
# Programs
.PHONY: $(BINARIES)

install: $(BINARIES)
	install -m 755 -d ${DESTDIR}${BINDIR}
	install -m 755 $(BUILDDIR)/skyd ${DESTDIR}${BINDIR}/skyd
	install -m 755 -d ${DESTDIR}${DATADIR}
