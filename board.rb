require_relative 'piece'
require_relative 'empty_piece'
require 'colorize'

class Board
	attr_reader :grid

	def initialize
		@grid = Array.new(10) { Array.new(10) {EmptyPiece.new} }
		populate_board

		@cursor_pos = [0,0]
		@selected_pos = nil
	end

	def select_pos
		@selected_pos = @cursor_pos
	end

	def cursor_pos
		@cursor_pos
	end

	def move_cursor(diff)
		cr, cc = @cursor_pos
		dr, dc = diff
		new_pos = [cr + dr, cc + dc]
		if on_board?(new_pos)
			@cursor = new_pos
		end
	end

	def do_moves
		raise "do_moves not implemented"
	end

	def can_move_more?
		raise "can_move_more? not implemented"
	end

	def valid_move_set
		raise "valid_move_set not implemented"
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
		puts "moving piece!"
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

	def [](pos)
    	row, col = pos
    	@grid[row][col]
  	end

  	def []=(pos, input)
    	row, col = pos
    	@grid[row][col] = input
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
  		if (ridx + cidx) % 2 == 1
  			print elem.to_s.on_red
  		else
  		 print elem.to_s.on_light_red
  		end
  	end

  	def on_board?(pos)
		pos.all? { |coord| (0..9).to_a.include?(coord) }
	end

end