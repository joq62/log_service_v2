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
-include("log.hrl").
%% --------------------------------------------------------------------
-export([start/0]).

-define(Pattern1,#log{log_node=Node,type=error,node=node_1,module=?MODULE,file=?FILE,line=?LINE,date={2020,12,25},time={15,00,00},msg='error 1'}).
%% ====================================================================
%% External functions
%% ====================================================================

%% --------------------------------------------------------------------
%% Function:emulate loader
%% Description: requires pod+container module
%% Returns: non
%% --------------------------------------------------------------------
start()->
    send_msg_1(),
    one_msg(),
    %all_msgs(),
 %   error(),
  %  event(),    
    ok.




%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
send_msg_1()->
    Node=node(),
    log_service:msg(),
    ok.

send_msg_all()-> 
    
%    log_service:msg({error,[node(),?MODULE,?FILE,?LINE,{2019,12,24},{15,00,00},'error 2']}),
 %   log_service:msg({error,[node(),?MODULE,?FILE,?LINE,{2020,12,23},{15,00,00},'error 3']}),
  %  log_service:msg({event,[node(),?MODULE,?FILE,?LINE,{2019,12,24},{14,59,59},'event 1']}), 
  %  ?LOG_INFO(error,'error 2'),
   % ?LOG_INFO(event,'event 1'),
   % ?LOG_INFO(event,'event 2'), 
    ok.   

one_msg()->
    Node=node(),
    {ok,[{in,{'$gen_cast',
	      {msg,LogMsg}}},
	      {Reply,State}]}=log_service:get(all),
    ?assertEqual({Node,error,node_1,{2020,12,25},{15,00,00},'error 1'},
		 {LogMsg#log.log_node,LogMsg#log.type,LogMsg#log.node,LogMsg#log.date,LogMsg#log.time,LogMsg#log.msg}),

%    ?assertEqual({ok,glurk},log_service:get(all)),
    ok.
    
all_msgs()->
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
