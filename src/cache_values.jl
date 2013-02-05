# NB: Given optimal values: p1.values = 1 - p2.values

using TicTacToe

p1 = TicTacToe.Player(1)
p2 = TicTacToe.Player(2)

itr = 0

thresholds = ["0_010_000",
              "0_050_000",
              "0_100_000",
              "0_500_000",
              "1_000_000",
              "5_000_000"]

for threshold in thresholds
    bound = parse_int(replace(threshold, "_", ""))

    while itr < bound
        itr +=1
        if rem(itr, 10_000) == 0
            @printf "Iteration %d\n" itr
        end
        TicTacToe.simulate_game!(p1, p2)
    end

    pathname = joinpath("cache",
                        string("p1values_", threshold, ".csv"))

    writecsv(pathname, p1.values)
end
