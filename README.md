TicTacToe.jl
============

The child's game, Tic-Tac-Toe, implemented in Julia.

This package provides a set of types for representing tic-tac-toe
games and a text-based UI for playing tic-tac-toe with another person
or against a computer. The AI players are trained using standard
Reinforcement Learning methods and can be configured for different
levels of difficulty. For details of the game AI setup, see Sutton and
Barto's textbook on Reinforcement Learning.

# Usage

    using TicTacToe
    play()

# Internal API Overview

If you want to modify the TicTacToe code, you'll want to understand
the Board and Player types that are defined in `board.jl` and `player.jl`.
If you want to modify the AI, you'll want to understand the training algorithm defined in `training.jl`.

## The Board Type

A `Board` object represents the state of a game of Tic-Tac-Toe.
For storage efficiency, it is represented using an array of
9 different 8-bit integers, each of which represents the state of
a single board position. The board positions are stored in this
array in an order that moves from left-to-right along rows and
then top-to-bottom along columns. For example, the Board below,

       | X | O 
     O | X |   
       | O | X 

is stored as,

    Board(Int8[0, 1, 2, 2, 1, 0, 0, 2, 1])

In general, the state array uses the following coding rule:

* 0's represent unoccupied locations
* 1's represent Player 1's moves
* 2's represent Player 2's moves

As you can tell, the string representation of board uses X's to
display Player 1's moves and O's to display Player 2's moves.

The benefit of this coding rule is that we can exploit its numeric
interpretation as a little-endian base 3 number to represent every
board using a  unique number between 0 and 19683. This is precisely
what the `board_to_index()` and `index_to_board()` functions do.
This equivalence between boards and integers is convenient because it
makes it trivial to storage the player's value function as a vector
of floating point numbers. The value function array is described later. You can use this coding rule by calling `board_to_index()` and
`index_to_board()` functions:

    board_to_index(Board(Int8[0, 1, 2, 2, 1, 0, 0, 2, 1]))
    # => 4220

    index_to_board(314)
    # =>    |   |   
    #    ---|---|---
    #     X |   | O 
    #    ---|---|---
    #     X | O | X 

## The Player Type

A `Played` object represents a human or computer played in a
game of Tic-Tac-Toe. A player has a `mark`, which is either 1 or 2,
and a `ishuman` tag, which determines whether the player is an AI or
not. If the player is an AI, then it uses three other fields:

* `values`: A vector of subjective values for every possible state of the board. Asymptotically, these values converge to the probability that player will win the game starting from that position.
* `alpha`: The learning rate used to back-propagate the value of a board position to previous positions during training.
* `beta`: The softmax decision rule's temperature. High values produce highly aggressive, non-exploratory decisions that are useful for competitive play, but make for poor learning. Low values improve learning, but make the game play sloppy.

## The Training Procedure

The AI's are trained by having two of them repeatedly play against each
other while doing standard TD reinforcement learning in which there is a reward of `1` for winning and a reward of `0` for losing. This allows the
value function to converge to the conditional probability of winning given the current state of the board. As such, the value functions are initialized to `0.5` by default. Reasonable value functions are cached in
the `cache` directory after 10,000; 50,000; 100,000; 500,000, 1,000,000
and 5,000,000 plays. These different cached values, as well as the beta
parameter, can be configured to make the game easier or harder to win.

# Configuring Gameplay

You can see how both the amount of learning and the aggressive of play
effect gameplay by configuring the cached values used and the temperature
of the softmax decision rule when calling `play()`. By default, `play()` is like calling:

    play("5_000_000", 100.0)

This means that you play against an adversary with 5,000,000 games of experience that very aggressively plays its best move at each turn. In
 contrast, you can play:

    play("0_010_000", 0.01)

This will give you an adversary with only 10,000 games of experience that will also choose moves almost completely at random. The experiences are very different. It is particularly interesting to experiment with in-between settings:

    play("5_000_000", 1.0)

This player is very experienced, but not very aggressive.

# Exercises / TODO

* Exploit symmetry: rotations and reflections of the board should have identical value function values
* Avoid making so many copies of data structures. This will make the code much faster. In particular, `move()` could be optimized.
* Watch the training process proceed in a naive AI that always plays against an sophisticated, unchanging AI. This is very different from the paired changes we can observe in our version of the game.
