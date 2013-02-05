module TicTacToe
    using Distributions

    import Base.show

    export play

    include("board.jl")
    include("player.jl")
    include("training.jl")
    include("ui.jl")
end
