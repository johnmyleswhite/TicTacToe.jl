include("src/TicTacToe.jl")
p1 = Player(1)
p2 = Player(2)
itr = 0
while itr < 10_000
	itr +=1
	simulate_game!(p1, p2)
end
writecsv("cache/p1values_10_000.csv", p1.values)
#	     (p1.values + (1 - p2.values)) / 2)
while itr < 100_000
	itr +=1
	simulate_game!(p1, p2)
end
writecsv("cache/p1values_100_000.csv", p1.values)
# etc...
