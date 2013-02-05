type Player
	mark::Int8
	values::Vector{Float64}
	alpha::Float64 # Alpha is the learning rate
	beta::Float64 # Beta is softmax temperature
end
Player(i::Real) = Player(int8(i), fill(0.5, 3^9), 0.1, 1.0)

function ishorizontalwin(p::Player, b::Board)
    return all(b.state[1:3] .== p.mark) |
            all(b.state[4:6] .== p.mark) |
            all(b.state[7:9] .== p.mark)
end
function isverticalwin(p::Player, b::Board)
    return all(b.state[[1, 4, 7]] .== p.mark) |
            all(b.state[[2, 5, 8]] .== p.mark) |
            all(b.state[[3, 6, 9]] .== p.mark)
end
function isdiagonalwin(p::Player, b::Board)
    return all(b.state[[1, 5, 9]] .== p.mark) |
            all(b.state[[3, 5, 7]] .== p.mark)
end

function iswin(p::Player, b::Board)
    if ishorizontalwin(p, b) | isverticalwin(p, b) | isdiagonalwin(p, b)
    	return true
    else
	    return false
	end
end

# TODO: Implement isdraw(p1, p2, b)

# TODO: Implement isloss(p1, p2, b)

# TODO: Implement ishorizontalloss(p1, p2, b)

# TODO: Implement isverticalloss(p1, p2, b)

# TODO: Implement isdiagonalloss(p1, p2, b)

function isfull(b::Board)
	return isempty(find(b.state .== 0))
end

function isdone(p1::Player, p2::Player, b::Board)
	return iswin(p1, b) | iswin(p2, b) | isfull(b) # | isdraw(p1, p2, b)
end

function move(p::Player, b::Board, index::Integer)
	if b.state[index] != 0
		error("Illegal move to $index attempted")
	end
	b_new = Board(copy(b.state))
	b_new.state[index] = p.mark
	return b_new
end

function available_moves(p::Player, b::Board)
    moves = {}
    indices = find(b.state .== 0)
    for index in indices
    	push!(moves, {index, move(p, b, index)})
    end
    return moves
end

function select_move(p::Player, b_current::Board)
	moves = available_moves(p, b_current)
	k = length(moves)
	if k == 0
		error("Game already done")
	end
	if k == 1
		return moves[1][2]
	end
	values = Array(Float64, k)
	for i in 1:k
		values[i] = exp(p.beta * p.values[board_to_index(moves[i][2])])
	end
	probs = values / sum(values)
	return moves[rand(Categorical(probs))][2]
end

function update_values!(p1::Player,
	                    p2::Player,
	                    b_previous::Board,
	                    b_current::Board)
	i_p = board_to_index(b_previous)
	i_c = board_to_index(b_current)
	if iswin(p1, b_current)
		p1.values[i_c] = 1.0
	end
	if iswin(p2, b_current)
		p1.values[i_c] = 0.0
	end
 	p1.values[i_p] += p1.alpha * (p1.values[i_c] - p1.values[i_p])
end
