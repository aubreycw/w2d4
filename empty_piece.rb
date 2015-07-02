class EmptyPiece

	def empty?
		true
	end

	def king?
		false
	end

	def to_s
		"   "
	end

	def color
		:none
	end

	def perform_move(dest)
		raise EmptyPieceError
	end

	def dup(board)
		EmptyPiece.new
	end
end