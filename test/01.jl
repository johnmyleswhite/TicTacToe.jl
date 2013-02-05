using TicTacToe

b = TicTacToe.Board(zeros(Int8, 9))
@assert isa(b, TicTacToe.Board)
@assert isa(b.state, Array{Int8})
@assert all(b.state .== 0)

b = TicTacToe.Board(ones(Int8, 9))
@assert isa(b, TicTacToe.Board)
@assert isa(b.state, Array{Int8})
@assert all(b.state .== 1)

state = zeros(Int8, 9); state[1] = 1; state[2] = 2
b = TicTacToe.Board(state)
@assert isa(b, TicTacToe.Board)
@assert isa(b.state, Array{Int8})
@assert all(b.state[1] == 1)
@assert all(b.state[2] == 2)

p1 = TicTacToe.Player(1)
@assert isa(p1, TicTacToe.Player)
p2 = TicTacToe.Player(2)
@assert isa(p2, TicTacToe.Player)

p = p1

for sim in 1:100
    TicTacToe.simulate_game!(p1, p2)
end

# TODO: Add assertions about iswin() and !iswin() here
ordered_boards = sortperm(p1.values)
TicTacToe.Board(TicTacToe.index_to_state(ordered_boards[1]))
TicTacToe.Board(TicTacToe.index_to_state(ordered_boards[1 + 1]))
TicTacToe.Board(TicTacToe.index_to_state(ordered_boards[1 + 2]))
TicTacToe.Board(TicTacToe.index_to_state(ordered_boards[end]))
TicTacToe.Board(TicTacToe.index_to_state(ordered_boards[end - 1]))
TicTacToe.Board(TicTacToe.index_to_state(ordered_boards[end - 2]))

# TODO: Add assertions about iswin() and !iswin() here
ordered_boards = sortperm(p2.values)
TicTacToe.Board(TicTacToe.index_to_state(ordered_boards[1]))
TicTacToe.Board(TicTacToe.index_to_state(ordered_boards[1 + 1]))
TicTacToe.Board(TicTacToe.index_to_state(ordered_boards[1 + 2]))
TicTacToe.Board(TicTacToe.index_to_state(ordered_boards[end]))
TicTacToe.Board(TicTacToe.index_to_state(ordered_boards[end - 1]))
TicTacToe.Board(TicTacToe.index_to_state(ordered_boards[end - 2]))

b = TicTacToe.Board(Int8[1, 1, 0, 2, 2, 0, 0, 0, 0])
p1.values[TicTacToe.board_to_index(b)]
p2.values[TicTacToe.board_to_index(b)]

b = TicTacToe.Board(Int8[1, 1, 1, 2, 2, 0, 0, 0, 0])
@assert TicTacToe.iswin(p1, b)
@assert !TicTacToe.iswin(p2, b)

b = TicTacToe.Board(Int8[1, 1, 1, 2, 2, 0, 0, 0, 0])
@assert TicTacToe.ishorizontalwin(p1, b)
@assert !TicTacToe.isverticalwin(p1, b)
@assert !TicTacToe.isdiagonalwin(p1, b)
@assert !TicTacToe.ishorizontalwin(p2, b)

b = TicTacToe.Board(Int8[1, 2, 0, 1, 2, 0, 1, 0, 0])
@assert TicTacToe.isverticalwin(p1, b)
@assert !TicTacToe.ishorizontalwin(p1, b)
@assert !TicTacToe.isdiagonalwin(p1, b)
@assert !TicTacToe.isverticalwin(p2, b)

b = TicTacToe.Board(Int8[1, 2, 0, 2, 1, 0, 0, 2, 1])
@assert TicTacToe.isdiagonalwin(p1, b)
@assert !TicTacToe.isverticalwin(p1, b)
@assert !TicTacToe.ishorizontalwin(p1, b)
@assert !TicTacToe.isdiagonalwin(p2, b)

b = TicTacToe.Board(Int8[2, 1, 2, 2, 1, 2, 1, 2, 1])
@assert TicTacToe.isgameover(p1, p2, b)

b = TicTacToe.Board(Int8[2, 1, 2, 2, 1, 2, 1, 2, 0])
@assert !TicTacToe.isgameover(p1, p2, b)
