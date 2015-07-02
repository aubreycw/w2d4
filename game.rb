class Game
	def initialize(player1, player2)
		@players = [player1, player2]
		@board = board.new
		@board.populate_board
	end

	def play
		until over?
			play_turn
		end
		puts "Game is over, #{players.last} has won."
	end

	def over?
	end

	def play_turn
	end

end