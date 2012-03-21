SRC = photo.js flickr.js main.js
CSS = screen.styl

all: photogrid.js screen.css

photogrid.js: $(SRC)
	cat $^ > $@

%.js: %.coffee
	coffee --compile --print $< > $@

%.css: %.styl
	stylus < $< > $@

clean:
	rm $(SRC) screen.css photogrid.js
