%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(log_test).  
   
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include_lib("eunit/include/eunit.hrl").
-include("syslog.hrl").
%% --------------------------------------------------------------------
-export([start/0]).

%% ====================================================================
%% External functions
%% ====================================================================

%% --------------------------------------------------------------------
%% Function:emulate loader
%% Description: requires pod+container module
%% Returns: non
%% --------------------------------------------------------------------
start()->
    send_msg(),
    all(),
    error(),
    event(),    
    ok.




%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
send_msg()->
  %  log_service:msg({error,[node(),?MODULE,?FILE,?LINE,date(),time(),'error 1']}),
    log_service:msg(?LOG_INFO(error,'error 1')),
    log_service:msg(?LOG_INFO(error,'error 2')),
    log_service:msg(?LOG_INFO(event,'event 1')),
    log_service:msg(?LOG_INFO(event,'event 2')),
%    log_service:msg({error,[node(),?MODULE,?FILE,?LINE,date(),time(),'error 2']}),  
%    log_service:msg({event,[node(),?MODULE,?FILE,?LINE,date(),time(),'event 1']}),
%    log_service:msg({event,[node(),?MODULE,?FILE,?LINE,date(),time(),'event 2']}),  
    ok.    

all()->
    Node=node(),
    ?assertMatch({ok,[{in,{'$gen_cast',{msg,{error,[Node,?MODULE,?FILE,_,_,_,'error 1']}}}},
		      {noreply,{state}},
		      {in,{'$gen_cast',{msg,{error,[Node,?MODULE,?FILE,_,_,_,'error 2']}}}},
		      {noreply,{state}},
		      {in,{'$gen_cast',{msg,{event,[Node,?MODULE,?FILE,_,_,_,'event 1']}}}},
		      {noreply,{state}},
		      {in,{'$gen_cast',{msg,{event,[Node,?MODULE,?FILE,_,_,_,'event 2']}}}},
		      {noreply,{state}}
		     ]},log_service:get(all)),
    ok.


error()->
    ?assertMatch([{error,[log_test@asus,log_test,"test_src/log_test.erl",Line1,Date_1,_Time1,'error 1']},
		  {error,[log_test@asus,log_test,"test_src/log_test.erl",Line2,Date2,_Time2,'error 2']}],log_service:get(error)),
    ok.

event()->
    ?assertMatch([{event,[log_test@asus,log_test,"test_src/log_test.erl",Line1,Date_1,_Time1,'event 1']},
		  {event,[log_test@asus,log_test,"test_src/log_test.erl",Line2,Date2,_Time2,'event 2']}],log_service:get(event)),
    ok.
