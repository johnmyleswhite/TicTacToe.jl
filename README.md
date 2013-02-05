# Usage Example

    include("src/TicTacToe.jl")

    using TicTacToe

    play()

# Internal API Overview

## The Board Type

A Board object represents the state of a game of Tic-Tac-Toe.
For storage efficiency, it is represented using an array of
9 different 8-bit integers, each of which represents the state of
a single board position. The board positions are stored in this
array in an order that moves from left-to-right along rows and
then top-to-bottom along columns. For example, the Board below,

       | X | O 
    ---|---|---
     O | X |   
    ---|---|---
       | O | X 

is stored as,

    Board(Int8[0, 1, 2, 2, 1, 0, 0, 2, 1])

In general, the state array uses the following coding rule:

* 0's represent unoccupied locations
* 1's represent Player 1's moves
* 2's represent Player 2's moves

As you can tell, the string representation of board uses X's to
display Player 1's moves and O's to display Player 2's moves.

The benefit of this coding rule is that exploit its clear numeric
interpretation as a little-endian number base 3 to represent every
board using a  unique number between 0 and 19683. This is precisely
what the `board_to_index()` and `index_to_board()` functions do.
This equivalence between boards and integers is convenient because it
makes it trivial to storage the player's value function, which is
described later. You can use this rule easily:

    board_to_index(Board(Int8[0, 1, 2, 2, 1, 0, 0, 2, 1]))
    # => 4220
    index_to_board(314)
    # =>    |   |   
    #    ---|---|---
    #     X |   | O 
    #    ---|---|---
    #     X | O | X 

## The Player Type

TO BE FILLED IN

## The Training Procedure

## Configuration Settings
