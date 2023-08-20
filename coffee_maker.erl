-module(coffee_maker).

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
	    turn_on_warmer();
	pot_empty ->
	    turn_off_warmer();
	boiler_empty ->
	    turn_off_boiler(),
	    coffee_ready();
	warmer_empty ->
	    open_relief_valve(),
	    turn_off_warmer()
    end.

coffee_ready() ->    
    turn_on_indicator(),
    standby().







start() ->
    spawn(fun() init() end).
