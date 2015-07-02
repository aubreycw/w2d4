require_relative 'board'
require_relative 'player'

class Game
	def initialize(player1, player2)
		@players = [player1, player2]
		@board = Board.new
		@board.populate_board
	end

	def play
		until over?
			play_turn
		end
		puts "Game is over, #{players.last} has won."
	end

	def play_turn
		moves = current_player.get_input
		if board.valid_moves?(moves)
			board.do_moves(moves)
			players << players.shift
		end
		puts "invalid move sequence "
	end

	def current_player
		players.first
	end

	def over?
		@board.over?
	end

	def test
		@board.render
	end

end

white = Player.new(:white)
black = Player.new(:black)

game = Game.new(white, black)

board = Board.new
board.render
board.move_piece([3,0], [4,1])
board.render
sleep(1)
board.move_piece([6,3],[5,2])
board.render
sleep(1)
board.move_piece([5,2], [3,0])
board.render

#write gameplay/cursor
	#selecting multiple jumps if ok
#write multiple jump move 

