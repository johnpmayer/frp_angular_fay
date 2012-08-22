
all: FRP.js

FAYC=fay
FAYFLAGS=--autorun

FRP.js: FRP.hs
	${FAYC} ${FAYFLAGS} FRP.hs

.PHONY: clean

clean:
	rm *.js
