require_relative 'board'
require_relative 'player'
require 'yaml'

class Game
	def initialize(player1, player2)
		@board = Board.new
		@board.populate_board
		player1.give_board(@board)
		player2.give_board(@board)
		@players = [player1, player2]
	end

	def play
		until over?
			begin
				play_turn
			rescue SaveGame 
				save_game
				retry
			end
		end
		puts "Game is over, #{@players.last.color} has won."
	end

	def play_turn
		moves = current_player.get_input
		if @board.valid_move_set?(moves)
			@board.do_moves!(moves)
			@players << @players.shift
			return nil
		end
		puts "invalid move sequence "
	end

	def current_player
		@players.first
	end

	def over?
		@board.over?
	end

	def test
		@board.render
	end

	def self.load_game(file_name)
		save = File.read(file_name+".yml")
     	YAML::load(save).play
	end

	def save_game
    	print "Enter the name you want your savefile to have (q to cancel): "
    	savename = "#{gets.chomp}.yml"
    	return if savename.downcase == "q.yml"
   	 	File.open(savename, 'w') do |f|
    	  f.puts self.to_yaml
    	end

    	puts "Game has been saved."
    	sleep(1)
    	return
  end
end

white = HumanPlayer.new(:white)
black = HumanPlayer.new(:black)

game = Game.new(white, black)

Game.load_game("test")

#neaten

#do simple AI

#do good AI

#do kings must capture or lose king (?)






