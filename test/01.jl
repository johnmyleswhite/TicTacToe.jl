include("src/TicTacToe.jl")

b = Board(zeros(Int8, 9))
b = Board(ones(Int8, 9))
state = zeros(Int8, 9)
state[1] = 1
state[2] = 2
b = Board(state)

p1 = Player(1)
p2 = Player(2)
p = p1

for sim in 1:10_000
    simulate_game!(p1, p2)
end

ordered_boards = sortperm(p1.values)
Board(index_to_state(ordered_boards[1]))
Board(index_to_state(ordered_boards[1 + 1]))
Board(index_to_state(ordered_boards[1 + 2]))
Board(index_to_state(ordered_boards[end]))
Board(index_to_state(ordered_boards[end - 1]))
Board(index_to_state(ordered_boards[end - 2]))

ordered_boards = sortperm(p1.values)
Board(index_to_state(ordered_boards[1]))
Board(index_to_state(ordered_boards[1 + 1]))
Board(index_to_state(ordered_boards[1 + 2]))
Board(index_to_state(ordered_boards[end]))
Board(index_to_state(ordered_boards[end - 1]))
Board(index_to_state(ordered_boards[end - 2]))

p1.values[state_to_index(Int8[1, 1, 0, 2, 2, 0, 0, 0, 0])]
Board(Int8[1, 1, 0, 2, 2, 0, 0, 0, 0])

