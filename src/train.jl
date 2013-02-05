function simulate_game!(p1::Player, p2::Player)
	p1_b_previous = Board()
	p2_b_previous = Board()
	b_current = Board()

    while !isdone(p1, p2, b_current)
    	# Update learned values
    	update_values!(p1, p2, p1_b_previous, b_current)
    	update_values!(p2, p1, p2_b_previous, b_current)

    	# Player 1 goes
    	p1_b_previous = Board(copy(b_current.state))
    	b_current = select_move(p1, b_current)

    	if !isdone(p1, p2, b_current)
    	    # Player 2 goes
    	    p2_b_previous = Board(copy(b_current.state))
    	    b_current = select_move(p2, b_current)
    	end
    end

    # Update learned values
    update_values!(p1, p2, p1_b_previous, b_current)
    update_values!(p2, p1, p2_b_previous, b_current)
end

function train_players!(p1::Player, p2::Player, nrounds::Integer)
	for i in 1:nrounds
	    simulate_game!(p1, p2)
	end
end
