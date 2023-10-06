-module(homework6_gen_server).

-behavior(gen_server).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

init(_Args) ->
    process_flag(trap_exit, true),
    io:format("hw6 server init~n"),
	Timer = erlang:send_after(10000, self(), check),
	gen_server:cast(self(),init),
	{ok, Timer}.

handle_call(Name, _From, State) ->
    {Command,Data} = Name,
    Reply = lists:flatten(io_lib:format("command ~s in myserver", [Command])),
    case Command of
        init -> 
          begin
            homework6:create(likaTable),
            io:format("hw6 create Table~n")
          end;  
        insert -> 
          begin
            homework6:insert(likaTable,Data),
            io:format("hw6 insert  ~p ~n",[Data])
          end;  
		runDeleteObsolete -> 
          begin
            homework6:delete_obsolete(likaTable),
            io:format("hw6 runDeleteObsolete  ~p ~n",[Data])
          end;     
    end,      
    {reply, Reply, State}.

handle_cast(runDeleteObsolete, State) ->
    io:format("hw6 runDeleteObsolete ~p ~n",[calendar:universal_time()]),
    {noreply, State};
	
handle_cast(init, State) ->
	homework6:create(likaTable),
    io:format("hw6 create Table~n"),
    {noreply, State};	
	
handle_cast(_Request, State) ->
    {noreply, State}.

handle_info(check, OldTimer) ->
  %erlang:cancel_timer(OldTimer),
  Timer = erlang:send_after(60000, self(), check),
  gen_server:cast(self(), runDeleteObsolete), 
  {noreply, Timer}.
    
terminate(_Reason, _State) ->
    io:format("hw6 server terminate~n"),
    [].

code_change(_OldVsn, _State, _Extra) ->
    {error, "NYI"}.
