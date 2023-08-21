-module(coffee_maker).

-export([start/0, start_trace/0]).

open_relief_valve() ->
    io:format("stubbed open relief valve~n").

turn_off_indicator() ->
    io:format("stubbed turn off indicator~n").

turn_on_indicator() ->
    io:format("stubbed turn on indicator~n").

turn_off_warmer() ->
    io:format("stubbed turn_off_warmer~n").

turn_on_warmer() ->
    io:format("stubbed turn_on_warmer~n").

turn_off_boiler() ->
    io:format("stubbed turn_off_boiler~n").

close_relief_valve() ->
    io:format("stubbed close_relief_valve~n").

turn_on_boiler() ->
    io:format("stubbed turn_on_boiler~n").


boot() ->
    receive 
	start ->
	    init()
    end.
    
    

init() ->
    open_relief_valve(),
    turn_off_indicator(),
    turn_off_warmer(),
    turn_off_boiler(),
    standby().


standby() ->
    receive 
	warmer_empty ->
	    turn_off_warmer(),
	    turn_off_indicator();
	pot_empty ->
	    turn_off_warmer(),
	    pot_empty();
	pot_not_empty ->
	    turn_on_warmer()
    end.

pot_empty() ->
    receive
	boiler_not_empty ->
	    ready();
	warmer_empty ->
	    standby();
	pot_not_empty ->
	    turn_on_warmer(),
	    standby()
    end.    

ready() ->
    receive 
	brew_button_pushed ->
	    close_relief_valve(),
	    turn_on_boiler(),
	    brewing();
	warmer_empty ->
	    standby();
	pot_not_empty ->
	    turn_on_warmer(),
	    standby()
    end.

brewing() ->
    receive 
	pot_not_empty ->
	    turn_on_warmer(),
	    brewing();
	pot_empty ->
	    turn_off_warmer(),
	    brewing();
	boiler_empty ->
	    turn_off_boiler(),
	    coffee_ready();
	warmer_empty ->
	    open_relief_valve(),
	    turn_off_warmer(),
	    brewing()
    end.	    

coffee_ready() ->    
    turn_on_indicator(),
    standby().







start() ->
    spawn(fun init/0).

start_trace() ->
    Pid = spawn(fun boot/0),
    tracer:trace_module_pid(coffee_maker, Pid),
    Pid.


-include_lib("eunit/include/eunit.hrl").


maker_ready_test() ->
    Maker = start_trace(),
    %% check relief valve open
    %% check warmer off
    %% check boiler off
    %% check indicator light off

brew_coffee_test() ->
    Maker = start_trace(),
    %% put the empty pot on the warmer
    Maker ! pot_empty,
    %% fill the boiler with water
    Maker ! boiler_not_empty,
    %% puts filter and coffee in filter holder and loads it
    Maker ! brew_button_pushed,
    %% check relief valve is closed
    %% check boiler is on
    %% simulate coffee is brewed
    Maker ! pot_not_empty,
    Maker ! boiler_empty,
    %% check indicator light is on
    %% check boiler heater is turned off
    
   
    
