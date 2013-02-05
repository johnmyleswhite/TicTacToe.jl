# Play a game with a text-based UI
function play(experience::String, beta::Float64)
    # Initialize the system
    b = Board()
    p1 = Player(1)
    p2 = Player(2)

    # Load cached values
    pathname = joinpath("cache", string("p1values_", experience, ".csv"))
    p1.values = squeeze(readcsv(pathname))
    p2.values = 1.0 - p1.values

    # Set randomness of play
    p1.beta = beta
    p2.beta = beta

    # Configure human players
    @printf "How many human players? "
    human_players = int(readline(STDIN))
    if human_players == 1
        @printf "Which player would you like to be? "
        response = int(readline(STDIN))
        if response == 1
            p1.ishuman = true
        else
            p2.ishuman = true
        end
    end
    if human_players == 2
        p1.ishuman = true
        p2.ishuman = true
    end

    # Perform the game loop
    while !isgameover(p1, p2, b)
        show(STDIN, b)
        @printf "\n"

        @printf "Player 1's turn\n\n"

        if p1.ishuman
            @printf "Where would you like to move? [1-9] "
            # TODO: Make 0 a way to quit the game early
            response = int(readline(STDIN))
            move_index = response
            @printf "\n"
            b = move(p1, b, move_index)
        else
            b = select_move(p1, b)
        end

        show(STDIN, b)
        @printf "\n"

        if isgameover(p1, p2, b)
            break
        end

        @printf "Player 2's move\n\n"

        if p2.ishuman
            @printf "Where would you like to move? [0-9] "
            response = int(readline(STDIN))
            move_index = response
            @printf "\n"
            try
                b = move(p2, b, move_index)
            catch
                # Need to handle illegal moves properly
                exit()
            end
        else
            b = select_move(p2, b)
        end
    end

    show(STDIN, b)
    @printf "\n"

    @printf "Game over!\n"
end

# Reasonable defaults
play() = play("5_000_000", 100.0)
