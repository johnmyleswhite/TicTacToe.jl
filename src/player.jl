type Player
    mark::Int8
    ishuman::Bool
    values::Vector{Float64}
    alpha::Float64 # Alpha is the learning rate
    beta::Float64 # Beta is softmax temperature
end

# Create a sensibly initialized player object
function Player(i::Real)
    Player(int8(i), false, fill(0.5, 3^9), 0.1, 1.0)
end

# Basic predicates about boards
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
    if ishorizontalwin(p, b) |
        isverticalwin(p, b) |
        isdiagonalwin(p, b)
        return true
    else
        return false
    end
end

function isfull(b::Board)
    return isempty(find(b.state .== 0))
end

function isgameover(p1::Player, p2::Player, b::Board)
    return iswin(p1, b) | iswin(p2, b) | isfull(b)
end

# Produce a hypothetical or real Board given a move location
function move(p::Player, b::Board, index::Integer)
    if b.state[index] != 0
        error("Illegal move to $index attempted")
    end
    b_new = Board(copy(b.state))
    b_new.state[index] = p.mark
    return b_new
end

# Enumerate all possibles moves as a pair that contains
# (position index, resulting board) in an Array{Any}
function available_moves(p::Player, b::Board)
    indices = find(b.state .== 0)
    k = length(indices)
    moves = Array(Any, k)
    for i in 1:k
        index = indices[i]
        moves[i] = {index, move(p, b, index)}
    end
    return moves
end

function select_move(p::Player, b_current::Board)
    # Determine all available moves
    moves = available_moves(p, b_current)

    # Handle edge cases when decisions are trivial
    k = length(moves)
    if k == 0
        error("Game over already!")
    end
    if k == 1
        return moves[1][2]
    end

    # Compute probabilities using the softmax decision rule
    values = Array(Float64, k)
    for i in 1:k
        ind = board_to_index(moves[i][2])
        values[i] = exp(p.beta * p.values[ind])
    end
    probs = values / sum(values)

    # Select a move probabilistically
    return moves[rand(Categorical(probs))][2]
end
