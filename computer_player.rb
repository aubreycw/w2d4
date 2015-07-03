require_relative 'player'
require_relative 'errors'
require_relative 'board'

#change moves in pieces to also include double jumps

class ComputerPlayer < Player

	def initialize(color, lookahead)
		super(color)
		@n = lookahead
	end

	def get_input
		possible_moves = moves(@board, @color)
		possible_boards = possible_moves.map { |move| make_move(board, [move]) }
		values = possible_boards.map { |board| minimax(@n-1, board, true)}
		best_index = values.each_with_index.max[1]
		[possible_moves[best_index]]
	end

	def minimax(n, board, my_turn)
		return value(board) if n == 0
		return value(board) if board.over?
		return -20 if board.stalemate?(@color)
		
		if my_turn
			possible_moves = moves(board, @color)
			possible_boards = possible_moves.map { |move| make_move(board, [move]) }
			values = possible_boards.map { |board| minimax(n-1, board, false)}
			values.max
		else
			possible_moves = moves(board, other_color)
			possible_boards = possible_moves.map { |move| make_move(board, [move]) }
			values = possible_boards.map { |board| minimax(n-1, board, true)}
			values.min
		end
	end

	def other_color
		@color == :black ? :white : :black
	end

	def moves(board, color)
		all_moves = []
		my_pieces = board.grid.flatten.select { |piece| piece.color == @color}
		my_pieces.each do |piece|
			initial_pos = piece.pos
			piece.moves.each do |final_pos|
				all_moves << [initial_pos, final_pos]
			end
		end
		all_moves
	end


	def value(board)
		# your pieces - opponents pieces
		result = 0
		board.grid.flatten.each do |elem|
			next if elem.empty?
			if elem.color == @color
				result += 1
			else
				result -= 1
			end
		end
		result
	end

	def make_move(board, moves)
		new_board = board.deep_dup
		new_board.do_moves!(moves)
		new_board
	end
end