require "IO/console"

class Player
	attr_accessor :board, :color

	def initialize(color)
		@color = color 
		@board = nil
	end

	def give_board(board)
		@board = board
	end

	def get_input
		raise "get_input not implemented"
	end
end

class HumanPlayer < Player
	KEYBINDINGS = {
  'w' => [-1, 0], 'a' => [0, -1],
  's' => [1, 0],  'd' => [0, 1]
	}

	def get_input
		input = nil
		until input
			input = input_from_cursor("it is #{color.to_s}'s turn")
		end
		input
	end

	def get_key
		input = $stdin.getch
		return input if ['w', 'a', 's', 'd', 'p', ' ', "\r"].include?(input)
		get_key
	end

	def input_from_cursor(message)
    board.render
    puts message
    selected_moves = []

    input = get_key # Player#get_input rescues bad input
    case input
    when ' '
      board.select_pos(@color)
      return nil

    when "\r"
      result = board.cursor_pos
      return nil if result.nil?
      if board.can_move_more?
      	selected_moves << result
      	return nil
      else
      	return selected_moves
      end

  	when "p"
  		return nil if selected_moves == []
  		return selected_moves
  	end

    else
      board.move_cursor(KEYBINDINGS[input])
      return nil
    end
  end

end
