# For now, just implement human being Player 1
function play()
	b = Board()
	p1 = Player(1)
	p2 = Player(2)

	# Load cached values
	p2.values = 1.0 - squeeze(readcsv("cache/p1values_100_000.csv"))
	p2.beta = 10.0

	@printf "Which player would you like to be? "
	if int(readline(STDIN)) == 1
		p_human = 1
		p_computer = 2
	else
		p_human = 2
		p_computer = 1
	end

	while !isdone(p1, p2, b)
		show(STDIN, b)
		@printf "\n"

		@printf "Where would you like to move? [0-9] "
		move_index = int(readline(STDIN))
		@printf "\n"
		b = move(p1, b, move_index)
		show(STDIN, b)
		@printf "\n"

		@printf "Player 2's move\n"
		@printf "\n"
		if !isdone(p1, p2, b)
			# Computer move
			b = select_move(p2, b)
		end
	end

	show(STDIN, b)
	@printf "\n"
	@printf "Game over!\n"
end
