create or replace procedure print_board(boolean) language plpgsql AS $$
declare
	counter integer :=0;
	tmp text;
	current_line text;
begin
	
	raise notice 'Here''s the % board:', case when $1 then 'final' else 'current' end;
	
	if not $1 then
		raise notice 'Enter your choice in the format ''x,y'' (zero based, left to right, top to bottom)';
	end if;

	raise notice '+---+---+---+';
	
	for counter in 1..9 loop
		if counter in (1,4,7) then
			current_line := '| ';
		end if;
		
		select player into tmp from claimed where pos = counter;
		
		current_line := current_line || coalesce(tmp, ' ') || ' | ';
		
		if counter in (3,6,9) then
			raise notice '%', current_line;
			raise notice '+---+---+---+';
		end if;
	end loop;
end $$;


create or replace function assert_claim(integer, text) RETURNS text AS $$
declare
	i integer := 0;
	winners text array := '{123,456,789,159,357,147,258,369}';
begin

	if exists (select * from claimed where pos = $1) then
		raise exception 'That cell is already selected.';
	end if;

	insert into claimed select $1, $2;

	for i in 1..array_length(winners,1) loop
		if position($1::text in winners[i]) = 0 then
			continue;  -- only test combinations that include current position
		end if;

		if 3 = (select count(*)
				from claimed as c,
					(select substr(winners[i], t, 1)::integer wpos
					 from generate_series(1,length(winners[i])) as t) as w
				where 
					c.player = $2
					and c.pos = w.wpos) then

			raise notice '% the winner!', case when $2 = 'x' then 'You are' else 'The computer is' end;
			call print_board(true);
			return $2;  -- we found a winner
		end if;
	end loop;

	if 9 = (select count(*) from claimed) then
		raise notice 'The game was a draw!';
		call print_board(true);
		return 'z';
	end if;

	return null;
end
$$ language plpgsql;

create or replace procedure take_turn(integer, integer) language plpgsql AS $$
declare 
	posn integer := 0;
	game_state text; 
begin

	if ($1 not between 0 and 2 or $2 not between 0 and 2) then 
		 raise exception 'Invalid input!  Try again.';
	end if;

	game_state := assert_claim(1+3*($2)+($1), 'x');
	if game_state is not null then
		return;
	end if;
	
	raise notice 'Computer is taking its turn...';
	select r into posn
			from generate_series(1,9) as r
	 		where not exists (select * from claimed where pos = r) 
			order by random() 
			limit 1;
	
	game_state := assert_claim(posn, 'o');
	if game_state is not null then
		return;
	end if;
	call print_board(false);
end $$;

create or replace procedure new_game() language plpgsql AS $$
begin
	drop table if exists claimed;
	create temp table claimed (pos integer,player text);
	raise notice 'Welcome to QC Coders'' Tic Tac Toe! You''re ''X'' and you''ll go first.';
	call print_board(false);
end $$;
