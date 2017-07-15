PACKAGE = tunctl
VERSION = 1.5
BIN = $(PACKAGE)

DIST = Makefile $(PACKAGE).spec $(PACKAGE).c

CFLAGS = -g -Wall

BIN_DIR ?= /usr/sbin

all : $(BIN)

$(BIN) : $(BIN).c
	$(CC) $(CFLAGS) -o $(BIN) $(BIN).c

clean : 
	rm -f $(BIN) $(OBJS)

install : $(BIN) $(MAN)
	install -d $(DESTDIR)$(BIN_DIR)
	install $(BIN) $(DESTDIR)$(BIN_DIR)

.PHONY: dist
dist: distcheck
	rm -rf dist/$(PACKAGE)-$(VERSION)
	mkdir -p dist/$(PACKAGE)-$(VERSION)
	cp -p $(DIST) dist/$(PACKAGE)-$(VERSION)
	tar -C dist -zcf $(PACKAGE)-$(VERSION).tar.gz $(PACKAGE)-$(VERSION)

distcheck:
	@if test "`awk '/^Version $(VERSION)($$|:)/ {print}' ChangeLog`" = ""; then \
	    echo "ERROR: Spec file ChangeLog not updated"; \
	    false; \
	fi
	@if test `awk '/^Version:/ {print $$2}' $(PACKAGE).spec` != $(VERSION); then \
	    echo "ERROR: Spec file version not updated"; \
	    false; \
	fi
	@if test "`awk '/^\*.* $(VERSION)-/ {print}' $(PACKAGE).spec`" = ""; then \
	    echo "ERROR: Spec file ChangeLog not updated"; \
	    false; \
	fi
