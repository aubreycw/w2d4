require_relative 'piece'
require_relative 'errors'
require_relative 'empty_piece'
require 'colorize'

class Board
	attr_reader :grid

	def initialize
		@grid = Array.new(10) { Array.new(10) {EmptyPiece.new} }
		populate_board

		@cursor_pos = [6,1]
		@selected_pos = nil
		@possible_moves = []
	end

	def select_pos(color, moves)
		crow, ccol = @cursor_pos
		puts "square to move to is color: #{@grid[crow][ccol].color.to_s}"
		if [color, :none].include?(@grid[crow][ccol].color)
			puts "inside if statement"
			@selected_pos = @cursor_pos
			update_possible_moves(moves)
		end
	end

	def update_possible_moves(moves)
		if moves == []
			row, col = @selected_pos
			@possible_moves = @grid[row][col].moves
		else
			last_row, last_col = moves.last.last
			test_board = self.deep_dup
			test_board.do_moves!(moves)
			@possible_moves = test_board.grid[last_row][last_col].moves
		end
	end

	def cursor_pos
		@cursor_pos
	end

	def selected_pos
		@selected_pos
	end

	def move_cursor(diff)
		cr, cc = @cursor_pos
		dr, dc = diff
		new_pos = [cr + dr, cc + dc]
		if on_board?(new_pos)
			@cursor_pos = new_pos
		end
	end

	def do_moves(moves)
		raise InvalidMoveError unless valid_move_set(moves)
		do_moves!(moves)
	end

	def do_moves!(moves)
		if moves.length == 1
			move_piece(moves[0].first, moves[0].last)
		else
			move_piece(moves[0].first, moves[0].last)
			do_moves!(moves.drop(1))
		end
	end

	def can_move_more?(moves)
		from_row, from_col= moves.last.first
		last_row, last_col = moves.last.last

		#checks that last move was a jump
		unless (from_row - last_row).abs + (from_col - last_col).abs == 4
			return false
		end

		#checks if there are any more jumps
		puts [last_row, last_col].to_s
		test_board = self.deep_dup
		puts "moves are: #{moves.to_s}"
		test_board.do_moves!(moves)
		moves = test_board.grid[last_row][last_col].moves
		puts moves.to_s
		moves.select do |move| 
			(last_row - move[0]).abs == 2  && (last_col - move[1]).abs == 2 
		end != []
	end

	def valid_move_set?(moves)
		begin 
			test_board = self.deep_dup
			test_board.do_moves!(moves)
		rescue InvalidMoveError
			return false
		end
		return true
	end


	def populate_board
		(0..3).each do |row|
			populate_row(row, :black)
		end
		(6..9).each do |row|
			populate_row(row, :white)
		end
	end

	def populate_row(row, color)
		(0..9).each do |col|
			next if (row + col) % 2 == 0
			@grid[row][col] = Piece.new(color, [row, col], self)
		end
	end

	def move_piece(origin, dest)
		ro, co = origin
		@grid[ro][co].perform_move(dest)
	end

	def move_piece!(origin, dest)
		rd, cd = dest
		ro, co = origin
		self.grid[rd][cd] = self.grid[ro][co]
		self.grid[ro][co] = EmptyPiece.new
	end

	def take_piece!(pos)
		r, c = pos
		self.grid[r][c] = EmptyPiece.new
	end

	def over?
		pieces = Hash.new {0}
		@grid.each do |row|
			row.each do |elem|
				pieces[elem.color] += 1
			end
		end
		pieces[:white] == 0 || pieces[:black] == 0
	end

  	def render
  		system("clear")
  		puts "   0  1  2  3  4  5  6  7  8  9"
  		@grid.each_with_index do |row, ridx|
  			print "#{ridx} "
  			row.each_with_index do |elem, cidx|
  				render_elem(elem, ridx, cidx)
  			end
  			puts
  		end
  	end

  	def render_elem(elem, ridx, cidx)
  		if [ridx, cidx] == @cursor_pos
  			print elem.to_s.on_magenta
  		elsif [ridx, cidx] == @selected_pos
  			print elem.to_s.on_blue
  		elsif @possible_moves.include?([ridx, cidx])
  			print elem.to_s.on_light_blue
  		elsif (ridx + cidx) % 2 == 1
  			print elem.to_s.on_red
  		else
  		 print elem.to_s.on_light_red
  		end
  	end

  	def on_board?(pos)
		pos.all? { |coord| (0..9).to_a.include?(coord) }
	end

  def deep_dup
    test_board = Board.new
    grid.each_with_index do |row, ridx|
      row.each_with_index do |elem, cidx|
        test_board.grid[ridx][cidx] = elem.dup(test_board)
      end
    end
	test_board
  end

  def grid
  	@grid
  end

  def empty?(pos)
  	row, col = pos
  	@grid[row][col].empty?
  end


end