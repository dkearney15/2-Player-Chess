require_relative 'piece'
require_relative 'cursorable.rb'
require_relative 'display.rb'
require 'byebug'

class Board

  attr_accessor :grid

  def initialize
    @grid = Array.new(8) { Array.new(8) { Piece.new } }
    add_pawns
    add_rooks
    add_bishops
    add_knights
    add_royalty
  end

  def move(start,finish)
    x_s, y_s = start
    x_f, y_f = finish
    raise 'Please enter a valid starting position.' if @grid[x_s][y_s].value.nil?
    raise 'Space already occupied.' if !@grid[x_f][y_f].value.nil?
  end

  def in_bounds?(pos)
    pos.all? { |x| x.between?(0, 7) }
  end

  def rows
    @grid
  end

  def in_check?(color)
    king_pos = find_king(color)
    if opposing_moves(color).include?(king_pos)
      return true
    end
    false
  end

  def opposing_moves(color)
    moves = []
    i = 0
    while i < self.grid.length
      n = 0
      while n < self.grid.length
        if self.grid[i][n].color != color
          moves += self.grid[i][n].moves
        end
        n += 1
      end
      i += 1
    end
    moves
  end

  def team_moves(color)
    moves = []
    i = 0
    while i < self.grid.length
      n = 0
      while n < self.grid.length
        if self.grid[i][n].color == color
          self.grid[i][n].in_bounds_moves([i, n]).each do |move|
            unless self.grid[i][n].value == " " 
              moves << [(self.grid[i][n].position), move, (self.grid[move[0]][move[1]])]
            end
            # each item in moves is an array length 3 
            # first: start position
            # second: finish position
            # third: finish piece
          end
        end
        n += 1
      end
      i += 1
    end
    moves
  end

  def find_king(color)
    i = 0
    while i < @grid.length
      n = 0
      while n < @grid.length

        if @grid[i][n].value == "\u2654" && color == 'white'
        	king_pos = [i,n]
        end

        if @grid[i][n].value == "\u265A" && color == 'black'
        	king_pos = [i,n]
        end

        n += 1
      end
      i += 1
    end
    king_pos
  end

  def pieces
  	@grid.flatten  
  end


  def add_pawns
    i = 0
    while i <= 7
      @grid[1][i] = Pawn.new("\u2659", self, 'white', [1,i])
      @grid[6][i] = Pawn.new("\u265F", self, 'black', [6,i])
      i += 1
    end
  end

  def add_rooks
    @grid[0][0] = Rook.new("\u2656", self, 'white', [0,0])
    @grid[0][7] = Rook.new("\u2656", self, 'white', [0,7])
    @grid[7][0] = Rook.new("\u265C", self, 'black', [7,0])
    @grid[7][7] = Rook.new("\u265C", self, 'black', [7,7])
  end

  def add_bishops
    @grid[0][2] = Bishop.new("\u2657", self, 'white', [0,2])
    @grid[7][2] = Bishop.new("\u265D", self, 'black', [7,2])
    @grid[0][5] = Bishop.new("\u2657", self, 'white', [0,5])
    @grid[7][5] = Bishop.new("\u265D", self, 'black', [7,5])
  end

  def add_knights
    @grid[0][1] = Knight.new("\u2658", self, 'white', [0,1])
    @grid[0][6] = Knight.new("\u2658", self, 'white', [0,6])
    @grid[7][1] = Knight.new("\u265E", self, 'black', [7,1])
    @grid[7][6] = Knight.new("\u265E", self, 'black', [7,6])
  end

  def add_royalty
    @grid[0][4] = King.new("\u2654", self, 'white', [0,4])
    @grid[0][3] = Queen.new("\u2655", self, 'white', [0,3])
    @grid[7][4] = King.new("\u265A", self, 'black', [7,4])
    @grid[7][3] = Queen.new("\u265B", self, 'black', [7,3])
  end


end
