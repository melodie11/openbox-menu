LIBS= `pkg-config --libs glib-2.0 gtk+-3.0 libmenu-cache`
CFLAGS+= -g -Wall `pkg-config --cflags glib-2.0 gtk+-3.0 libmenu-cache`
CC=gcc
#-DG_DISABLE_DEPRECATED

# Comment this line if you don't want icons to appear in menu
CFLAGS+=-DWITH_ICONS
# Comment this line if Openbox should not display SVG icons
CFLAGS+=-DWITH_SVG
# If the Openbox version installed supports SVG the command line '$ ldd /usr/bin/openbox | grep svg', will show librsvg.

prefix= /usr/local
DESTDIR ?= $(prefix)
BINDIR= ${DESTDIR}/bin

SRC= $(shell ls src/*.c 2> /dev/null)
OBJ= $(SRC:.c=.o)

all: $(OBJ) check openbox-menu

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@


openbox-menu: $(OBJ)
	$(CC) $(OBJ) -o openbox-menu $(LDFLAGS) $(LIBS)

.PHONY: clean install doc changelog check xmllint

clean:
	@rm -f $(OBJ) $(TEST_OBJ) openbox-menu check
	@rm -rf doc

install:
	@strip -s openbox-menu
	@install -Dm 755 openbox-menu $(BINDIR)/openbox-menu

doc:
	robodoc --src . --doc doc/ --multidoc --index --html --cmode

xmllint: openbox-menu
	./openbox-menu > test.xml
	xmllint test.xml
	rm test.xml

changelog:
	@hg log --style changelog > ChangeLog
