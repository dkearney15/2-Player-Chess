
class Piece
  attr_accessor :value, :color, :position, :valid_moves

  def initialize(value = " ", board = nil, color = nil, position = nil)
    @value = value
    @color = color
    @position = position
    @board = board
    @moves = []
    @valid_moves = []
  end

  def moves
    @moves
  end

  def in_bounds?(pos)
    pos.all? { |x| x.between?(0, 7) }
  end

  def valid_move?(start,finish)
    move_set = in_bounds_moves(start)
    @valid_moves = move_set
    move_set.include?(finish)
  end

  def in_bounds_moves(start)
    all_moves = @board.grid[start[0]][start[1]].moves
    all_moves.select { |move| in_bounds?(move) }
  end

end


class SlidingPiece < Piece
  def direction(x,y)

    moves = []
      i, j = position[0] + x, position[1] + y
      until i > 7 || j > 7 || (@board.grid[i][j].value != " " )
          moves << [i,j]
          i, j = i + x, j + y
      end
      if i < 8 && j < 8 && @board.grid[i][j].color != self.color
        moves << [i,j]
        return moves
      end
     moves

  end
end


class Pawn < Piece
  
  def forward_moves
    forward_moves = []
    if color == "white" 
      
      if position[0] + 1 < 8 && @board.grid[position[0] + 1][position[1]].value == " "
        forward_moves << [position[0] + 1, position[1]]
      end

      if position[0] == 1 && @board.grid[3][position[1]].value == " "
        forward_moves << [3, position[1]]
      end

    else
      
      if position[0] - 1 > -1 && @board.grid[position[0] - 1][position[1]].value == " "
        forward_moves << [position[0] - 1, position[1]]
      end

      if position[0] == 6 && @board.grid[4][position[1]].value == " "
        forward_moves << [4, position[1]]
      end

    end

    forward_moves
  end

  def attacks
    if color == "white"
      attacks = [[position[0] + 1, position[1] + 1], [position[0] + 1, position[1] - 1]]
      attacks.reject! { |move| move[0] > 7 || move[1] > 7 }
      attacks.reject! { |move| move[0] < 0 || move[1] < 0 }
      attacks.reject! { |move| @board.grid[move[0]][move[1]].value == " "}
      attacks.reject! { |move| @board.grid[move[0]][move[1]].color == "white"}
    else
      attacks = [[position[0] - 1, position[1] + 1], [position[0] - 1, position[1] - 1]]
      attacks.reject! { |move| move[0] > 7 || move[1] > 7 }
      attacks.reject! { |move| move[0] < 0 || move[1] < 0 }
      attacks.reject! { |move| @board.grid[move[0]][move[1]].value == " "}
      attacks.reject! { |move| @board.grid[move[0]][move[1]].color == "black"}
    end
    attacks
  end

  def moves
    forward_moves + attacks
  end

end

class King < Piece
  def moves
    moves = []
    [0, -1, -1, 1, 1].permutation(2).to_a.uniq.each do |move|
      new_move = [move[0] + position[0], move[1] + position[1]]
      moves << new_move if in_bounds?(new_move)
    end
    moves.select { |move| @board.grid[move[0]][move[1]].color != self.color }
  end
end

class Knight < Piece
  def moves
    moves = []
    [[1,-2],[2,-1],[2,1],[1,2],[-1,2],[-2,1],[-2,-1],[-1,-2]].each do |move|
      new_move = [move[0] + position[0], move[1] + position[1]]
      moves << new_move if in_bounds?(new_move)
    end
    moves.select { |move| @board.grid[move[0]][move[1]].color != self.color }
  end
end

class Bishop < SlidingPiece
  def moves
    direction(1,1) + direction(-1,-1) + direction(-1,1) + direction(1,-1)
  end
end

class Rook < SlidingPiece
  def moves
    direction(1,0) + direction(-1, 0) + direction(0,1) + direction(0,-1)
  end
end

class Queen < SlidingPiece
  def moves
    direction(1,1) + direction(-1,-1) + direction(-1,1) + direction(1,-1) +
    direction(1,0) + direction(-1, 0) + direction(0,1) + direction(0,-1)
  end
end
