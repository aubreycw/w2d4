require_relative 'errors'
require 'colorize'

class Piece
	attr_reader :king, :color
	attr_accessor :board

	def initialize(color, pos, board, king = false)
		@color, @pos, @board, @king = color, pos, board, king
		@cursor_pos = [0,0]
		@selected_pos = nil
	end


	def moves
		all_moves = []
		row, col = @pos
		move_diffs.each do |move_diff|
			drow1, dcol1 = move_diff
			new_move = [row + drow, col + dcol]
			if is_valid_slide?(new_move) || is_valid_jump?(new_move)
				all_moves << new_move
			end
		end
		all_moves
	end

	def perform_move(new_pos)
		puts "performing move"
		if valid_slide?(new_pos)
			puts "valid slide"
			perform_slide(new_pos) 
			return
		elsif valid_jump?(new_pos)
			puts "valid jump"
			perform_jump(new_pos)
			return
		end
		raise InvalidMoveError
	end

	def perform_slide(new_pos)
		unless valid_slide?(new_pos)
			raise InvalidSlideError
		end
		board.move_piece!(@pos, new_pos)
		@pos = new_pos 
	end

	def perform_jump(new_pos)
		unless valid_jump?(new_pos)
			raise InvalidJumpError
		end

		#finds location of jumped piece
		nr, nc = new_pos
		cr, cc = @pos
		jump_piece_row = cr + (nr - cr)/2
		jump_piece_col = cc + (nc - cc)/2

		board.move_piece!(@pos, new_pos)
		@pos = new_pos
		board.take_piece!([jump_piece_row, jump_piece_col])
	end

	def valid_slide?(new_pos)
		return false unless on_board?(new_pos) && board[new_pos].empty?
		new_pos.zip(@pos).all? {|new_p, current_p| (new_p - current_p).abs == 1}
	end

	def valid_jump?(new_pos)
		return false unless on_board?(new_pos) && board[new_pos].empty?
		return false unless new_pos.zip(@pos).all? do |new_p, current_p|
			 (new_p - current_p).abs == 2
		end

		#finds location of jumped piece
		nr, nc = new_pos
		cr, cc = @pos
		jump_piece_row = cr + (nr - cr)/2
		jump_piece_col = cc + (nc - cc)/2
		jump_piece = board[[jump_piece_row, jump_piece_col]]

		!jump_piece.empty? && jump_piece.color != self.color
	end

	def move_diffs
		if king?
			return [[1, 1], [1, -1], [-1, 1], [-1, -1],
					[2, 2], [2, -2], [-2, 2], [-2, -2]]
		end
		dir = @color == :black ? 1 : -1
		[[dir, 1], [dir, -1], [dir*2, 2], [dir*2, -2]]
	end

	def maybe_promote
		return false if king?
		if self.color == :black && pos[0] == 9
			@king = true
			return true
		elsif self.color == :white && pos[0] == 0
			@king = true
			return true
		end
		false
	end

	def king?
		self.king
	end

	def on_board?(pos)
		pos.all? { |coord| (0..9).to_a.include?(coord) }
	end

	def empty?
		false
	end

	def to_s
		return " ♛ ".colorize(color)if king?
		" ⬤ ".colorize(color)
	end

	def dup
		puts "duping piece"
		Piece.new(@color, @pos, @board, @king)
	end

end