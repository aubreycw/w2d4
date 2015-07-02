class InvalidMoveError < StandardError
end

class InvalidJumpError < InvalidMoveError
end

class InvalidSlideError < InvalidMoveError
end

class EmptyPieceError < InvalidMoveError
end