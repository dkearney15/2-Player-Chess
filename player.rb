require_relative "display"


class Player
  attr_reader :color
  def initialize(board, color)
    @board = board
    @color = color
    @display = Display.new(board)
  end

  def take_turn

    if @board.in_check?(self.color)
      puts "#{self.color.capitalize} is in Check!"
      sleep(1)
    end

    selected = false
    valid_finish = false
    result = nil
    start = nil
    finish = nil
    until result
      until selected
        start = get_pos("Choose a piece, #{self.color}.")
        selected = valid_selected?(start)
      end 
        finish = get_pos("Choose a place to put it, #{self.color}")
        finish_piece = @board.grid[finish[0]][finish[1]]
        valid_finish = @board.grid[start[0]][start[1]].valid_move?(start, finish)
        if valid_finish == false
          puts "Invalid move."
          sleep(0.5)
          selected = false
        else 
          move(start, finish)
          if @board.in_check?(self.color)
            undo_move(start, finish, finish_piece)
            puts "Cannot move into check."
            sleep(0.5)
            selected = false
            result = false
          else
            pawn_promotion
            result = true
          end
      end
    end
    result
  end

  def other_color
    return "black" if self.color == "white"
    return "white" if self.color == "black"
  end

  def checkmate?(color)
    return false unless @board.in_check?(color)
    @board.team_moves(color).each do |trio|
      move(trio[0], trio[1])
      if @board.in_check?(color)
        undo_move(trio[0], trio[1], trio[2])
      else
        undo_move(trio[0], trio[1], trio[2])
        return false
      end
    end
    true
  end

  def move(start, finish)
    @board.grid[finish[0]][finish[1]] = @board.grid[start[0]][start[1]]
    @board.grid[finish[0]][finish[1]].position = finish
    @board.grid[start[0]][start[1]] = Piece.new
  end

  def undo_move(start, finish, finish_piece)
    @board.grid[start[0]][start[1]] = @board.grid[finish[0]][finish[1]]
    @board.grid[start[0]][start[1]].position = start
    @board.grid[finish[0]][finish[1]] = finish_piece
  end

  def get_pos(string)
    pos = nil
    while pos.nil?
      @display.render
      puts string
      input = @display.get_input
      if input.is_a?(Array)
        pos = input
      end
    end
    pos
  end

  def valid_selected?(input)
    x, y = input
    return true if @board.grid[x][y].color == self.color
    false
  end

  def pawn_promotion
    i = 0
    while i < 8
      if @board.grid[0][i].value == "\u265F"
        @board.grid[0][i] = Queen.new("\u265B", @board, "black", [0, i])
        puts "Pawn promotion!"
        sleep (0.5)
      end
      i += 1
    end

    j = 0
    while j < 8
      if @board.grid[7][j].value == "\u2659"
        @board.grid[7][j] = Queen.new("\u2655", @board, "white", [7, j])
        puts "Pawn promotion!"
        sleep (0.5)
      end
      j += 1
    end

  end

end
