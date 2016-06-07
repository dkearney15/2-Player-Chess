require_relative 'board.rb'
require_relative 'player.rb'

class Game

  def initialize
    @board = Board.new

    @display = Display.new(@board)
    @white_player = Player.new(@board, "white")
    @black_player = Player.new(@board, "black")

    run_game
  end

  def run_game
    until false
      if @white_player.checkmate?("white") 
        puts "Checkmate!"
        puts "Black wins!"
        break
      elsif @black_player.checkmate?("black")
        puts "Checkmate!"
        puts "White wins"
        break
      end  
      pos = @white_player.take_turn
       if @white_player.checkmate?("white") 
        puts "Checkmate!"
        puts "Black wins!"
        break
      elsif @black_player.checkmate?("black")
        puts "Checkmate!"
        puts "White wins"
        break
      end 
      @black_player.take_turn
    end
    puts "GAME OVER"
  end

end


if __FILE__ == $PROGRAM_NAME
  Game.new
end
