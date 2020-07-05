all:
	rm -rf  logfiles *_service include *~ */*~ */*/*~;
	rm -rf *.beam erl_crash.dump */erl_crash.dump */*/erl_crash.dump;
	cp src/*.app ebin;
	erlc -I ../include -o ebin src/*.erl;
doc_gen:
	rm -rf  node_config logfiles doc/*;
	erlc ../doc_gen.erl;
	erl -s doc_gen start -sname doc

test:
	rm -rf  include logfiles latest.log;
	rm -rf *.beam ebin/* test_ebin/* erl_crash.dump;
#	include
	git clone https://github.com/joq62/include.git;
	cp src/*app ebin;
	erlc -I include -o ebin src/*.erl;
	erlc -I include -o test_ebin test_src/*.erl;
	erl -pa ebin -pa test_ebin -s log_service_tests start -sname log_test
