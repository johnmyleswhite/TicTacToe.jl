function update_values!(p1::Player,
                        p2::Player,
                        b_previous::Board,
                        b_current::Board)
    # Cache the indices of the previous and current boards
    i_p = board_to_index(b_previous)
    i_c = board_to_index(b_current)

    # Make sure that wins and losses are hardcoded appropriately
    if iswin(p1, b_current)
        p1.values[i_c] = 1.0
    end
    if iswin(p2, b_current)
        p1.values[i_c] = 0.0
    end
    if isfull(b_current)
        p1.values[i_c] = 0.5
    end

    # Move previous state's towards current state's value
    p1.values[i_p] += p1.alpha * (p1.values[i_c] - p1.values[i_p])
end

function simulate_game!(p1::Player, p2::Player)
    # Initialize the system
    b_previous = Board()
    b_current = Board()

    while !isgameover(p1, p2, b_current)
        # Player 1 moves
        b_previous = b_current
        b_current = select_move(p1, b_current)

        # Update both players' learned values
        update_values!(p1, p2, b_previous, b_current)
        update_values!(p2, p1, b_previous, b_current)

        # Player 2 moves if game is not over yet
        if !isgameover(p1, p2, b_current)
            b_previous = b_current
            b_current = select_move(p2, b_current)

            # Update both players' learned values
            update_values!(p1, p2, b_previous, b_current)
            update_values!(p2, p1, b_previous, b_current)
        end
    end
end
