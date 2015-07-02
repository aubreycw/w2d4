class Piece
	attr_reader :king, :color

	def initialize(color, board, pos, king = false)
		@color, @board, @pos, @king = color, board, pos, king
	end

	def moves
	end

	def perform_slide(new_pos)
		unless valid_slide?(new_pos)
			raise InvalidSlideError
		end
		@pos = new_pos 
		board.move_piece!(self, pos)
	end

	def perform_jump
	end

	def valid_slide?(new_pos)
	end

	def valid_jump(new_pos)
	end

	def move_diffs
		return [[1, 1], [1, -1], [-1, 1], [-1, -1]] if king?
		dir = @color == :black ? 1 : -1
		[[dir, 1], [dir, -1]]
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

end