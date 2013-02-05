type Board
    state::Array{Int8}
end
Board() = Board(zeros(Int8, 9))

function show(io::IO, b::Board)
    for ind in 1:9
        i = fld(ind - 1, 3) + 1
        j = rem(ind - 1, 3) + 1
        if b.state[ind] == 1
            print(" X ")
        elseif b.state[ind] == 2
            print(" O ")
        else
            print("   ")
        end
        if j < 3
            print("|")
        else
            print("\n")
            if i < 3
                print("---|---|---\n")
            end
        end
    end
end

function state_to_index(state::Array{Int8})
    res = 1
    for i in 9:-1:1
        p = 9 - i
        res += state[i] * 3^p
    end
    return res
end
board_to_index(b::Board) = state_to_index(b.state)

function index_to_state(index::Integer)
    index = index - 1
    state = Array(Int8, 9)
    for i in 1:9
        p = 9 - i
        state[i] = fld(index, 3^p)
        index = rem(index, 3^p)
    end
    return state
end
index_to_board(index::Integer) = Board(index_to_state(index))
