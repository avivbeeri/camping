.PHONY: synth.dylib
synth.dylib: synth.c
	gcc -dynamiclib -o synth.dylib synth.c -undefined dynamic_lookup -O3
	cp synth.dylib ../

synth.so:
	gcc -shared -o synth.so -fPIC synth.c -O3
