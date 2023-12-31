-module(tracer).
-include_lib("stdlib/include/ms_transform.hrl").
-export([trace_module/2, trace_module_pid/2]).

%% www.otp.org/doc/man/ms_transform.html


trace_module(Mod, StartFun) ->
    %% We'll spawn a process to do the tracing
    spawn(fun() -> trace_module1(Mod, StartFun) end).

trace_module_pid(Mod, Pid) ->
    spawn(fun() -> trace_module_pid1(Mod, Pid) end).

trace_module_pid1(Mod, Pid) ->
    %% The next line says: trace all function calls and return
    %%                     values in Mod
    erlang:trace_pattern({Mod, '_','_'},  
			 [{'_',[],[{return_trace}]}], 
			 [local]),
    %% setup the trace. Tell the system to start tracing 
    %% the process Pid
    erlang:trace(Pid, true, [call,procs]),
    %% Now tell Pid to start
    Pid ! start,
    trace_loop().


trace_module1(Mod, StartFun) ->
    %% The next line says: trace all function calls and return
    %%                     values in Mod
    erlang:trace_pattern({Mod, '_','_'},  
			 [{'_',[],[{return_trace}]}], 
			 [local]),
    %% spawn a function to do the tracing
    S = self(),
    Pid = spawn(fun() -> do_trace(S, StartFun) end),
    %% setup the trace. Tell the system to start tracing 
    %% the process Pid
    erlang:trace(Pid, true, [call,procs]),
    %% Now tell Pid to start
    Pid ! {self(), start},
    trace_loop().

%% do_trace evaluates StartFun()
%%    when it is told to do so by Parent
do_trace(Parent, StartFun) ->
    receive
	{Parent, start} ->
	    StartFun()
    end.

%% trace_loop displays the function call and return values
trace_loop() ->
    receive
	{trace,_,call, X} ->
	    io:format("Call: ~p~n",[X]),
	    trace_loop();
	{trace,_,return_from, Call, Ret} ->
	    io:format("Return From: ~p => ~p~n",[Call, Ret]),
	    trace_loop();
	Other ->
	    %% we get some other message - print them
	    io:format("Other = ~p~n",[Other]),
	    trace_loop()
    end.
