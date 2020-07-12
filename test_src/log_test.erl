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
%-include_lib("eunit/include/eunit.hrl").
-include("log.hrl").
%% --------------------------------------------------------------------
-export([start/0]).

-define(Pattern1,#log{log_node=Node,type=error,node=node_1,module=module_1,file=file_1,line=line_1,date={2020,12,25},time={15,00,00},msg='error 1'}).
-define(Result1,{Node,error,node_1,module_1,file_1,line_1,{2020,12,25},{15,00,00},'error 1'}).
%    log_service:msg({error,[node(),?MODULE,?FILE,?LINE,{2019,12,24},{15,00,00},'error 2']}),
 

-define(Pattern2,#log{log_node=Node,type=error,node=node_2,module=module_2,file=file_2,line=line_2,date={2019,12,24},time={15,00,00},msg='error 2'}).
-define(Result2,{Node,error,node_1,module_1,file_1,line_1,{2019,12,24},{15,00,00},'error 2'}).

 %   log_service:msg({error,[node(),?MODULE,?FILE,?LINE,{2020,12,23},{15,00,00},'error 3']}),
-define(Pattern3,#log{log_node=Node,type=error,node=node_3,module=module_3,file=file_3,line=line_3,date={2020,12,23},time={15,00,00},msg='error 3'}).
-define(Result3,{Node,error,node_3,module_3,file_3,line_3,{2020,12,23},{15,00,00},'error 3'}).
  %  log_service:msg({event,[node(),?MODULE,?FILE,?LINE,{2019,12,24},{14,59,59},'event 1']}),
-define(Pattern4,#log{log_node=Node,type=error,node=node_4,module=module_4,file=file_4,line=line_4,date={2020,12,23},time={14,59,59},msg='event 1'}).
-define(Result4,{Node,event,node_4,module_4,file_4,line_4,{2020,12,23},{14,59,59},'event 1'}).
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
    send_msg_all(),
 %   one_msg(),
    send_msg_all(),
  %  all_msgs(),
    log_get(),
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
    log_service:msg(?Pattern1),
    ok.

send_msg_all()-> 
    Node=node(),
    log_service:msg(?Pattern2),   
  %  log_service:msg(?Pattern3),    
  %  log_service:msg(?Pattern4),     
    ok.   

one_msg()->
    Node=node(),
    {ok,R}=log_service:get(all),
    io:format("~p~n",[{?MODULE,?LINE,R}]),
 %   {in,{'$gen_cast',{msg,{log,log_test@asus,error,node_1,module_1,
%			   file_1,line_1,
%			   {2020,12,25},
%			   {15,0,0},
%			   'error 1'}}}},
    {noreply,{state}},
    R2=[LogMsg1||{in,{'$gen_cast',{msg,LogMsg1}},{Reply,State}}<-R],
%    {ok,[{in,{'$gen_cast',
%	      {msg,LogMsg}}},
%	      {Reply,State}]}=log_service:get(all),
    glurk=R2,
 %  [LogMsg]=R2,
    LogMsg=glurk,
 %  ?assertEqual(?Result1,
%		 {LogMsg#log.log_node,LogMsg#log.type,LogMsg#log.node,
%		  LogMsg#log.module,LogMsg#log.file,LogMsg#log.line,LogMsg#log.date,LogMsg#log.time,LogMsg#log.msg}),

    ok.
    
all_msgs()->

    Node=node(),
    {ok,R}=log_service:get(all),
    io:format("~p~n",[{?MODULE,?LINE,R}]),
  %  R2=[LogMsg1||{in,{'$gen_cast',{msg,LogMsg1}}},{Reply,State}<-R],
    ok.


log_get()->
    R=log_service:get(all),
 %   io:format("~p~n",[{?MODULE,?LINE,R}]),
    Node=node(),
    LogServices=[{"log_service",Node}], % dns_service:get("log_service"),
    LogInfo=[{node(),rpc:call(N,log_service,get,[all])}||{_,N}<-LogServices],
 %   io:format("LogInfo ~p~n",[{?MODULE,?LINE,LogInfo}]),
    R2=filter(LogInfo),
 %   io:format("filter ~p~n",[{?MODULE,?LINE,R2}]),
  
    R3=add_calendar_time(R2),
    io:format("calendar time added ~p~n",[{?MODULE,?LINE,R3}]),
    
   % R3=[{calendar:datetime_to_gregorian_seconds({{Y,M,D},{H,Min,S}}),{OrgNode,{Type1,[Node,Module,File,Line,{Y,M,D},{H,Min,S},Msg]}}}||
%	  {OrgNode,{Type1,[Node,Module,File,Line,{Y,M,D},{H,Min,S},Msg]}}<-filter(LogInfo)],
  %  Q=qsort(R),
%    ?assertMatch(glurk,qsort(R)).
%    io:format("~p~n",[{?MODULE,?LINE,qsort(R)}]),
   % ?assertMatch(glurk,qsort(R)).
    glurk=ok.

add_calendar_time([])->
    [];
add_calendar_time(X)->
    add_calendar_time(X,[]).
add_calendar_time([],R) ->
    R;
add_calendar_time([{Node,InMsg,{OutMsg,State}}|T],Acc) ->
    {in,{_,{msg,Info}}}=InMsg,
    Calendar=calendar:datetime_to_gregorian_seconds({Info#log.date,Info#log.time}),
    add_calendar_time(T,[{Calendar,Node,Info,{OutMsg,State}}|Acc]);
add_calendar_time(X,_) ->
    io:format("error calendar ~p~n",[{?MODULE,?LINE,X}]),
    glurk=ok.


filter([])->
    [];	 
filter([{Node,ListInOutState}])->
    filter(ListInOutState,Node,[]).
filter([],_,R)->
    R;
filter([InMsg,OutMsgState|T],Node,Acc)->
    filter(T,Node,[{Node,InMsg,OutMsgState}|Acc]).

qsort([])->[];
qsort([{Pivot,Info}|T])->

    qsort([{OrgNode,{Type,[Node,Module,File,Line,{Y,M,D},{H,Min,S},Msg]}}||{DateSeconds,{OrgNode,{Type,[Node,Module,File,Line,{Y,M,D},{H,Min,S},Msg]}}}<-T,
								     DateSeconds<Pivot]) ++ [Info] ++
    qsort([{OrgNode,{Type,[Node,Module,File,Line,{Y,M,D},{H,Min,S},Msg]}}||{DateSeconds,{OrgNode,{Type,[Node,Module,File,Line,{Y,M,D},{H,Min,S},Msg]}}}<-T,
									 DateSeconds>=Pivot]).
