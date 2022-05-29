all: libbcm2835

clean:
	rm -f *.o libbcm2835.so

install:
	cp libbcm2835.so /usr/local/lib/

libbcm2835:
	ar -x /usr/local/lib/libbcm2835.a
	ld -shared -o libbcm2835.so *.o
	# nm -gD libbcm2835.so
