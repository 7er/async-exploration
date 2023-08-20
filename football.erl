-module(football).
-export([kickoff/0, play/0, goal/0, showCelebration/1]).

kickoff() ->
    play().

play() ->	     
    io:format("playing!!!!"),
    receive
	{pass, Player} -> 
	    Player ! receiveBall,
	    io:format("Passing to ");
	{shoot, Player, Goal} -> 
	    io:format("Goal!!!" ++ Goal),
	    goal()
%	{Any, Player} -> 
%	    kill(Player);
%	{Any, Player, Any2} ->
%	    kill(Player)
    end,
    play().

goal() ->
    receive 
	{celebrate, Celebration} ->
	    showCelebration(Celebration),
	    kickoff()
    end.

showCelebration(Celebration) ->
    io:format("Celebrating by " ++ Celebration).

	
