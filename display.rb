require "colorize"
require_relative "cursorable"

class Display
  include Cursorable

  def initialize(board)
    @board = board
    @cursor_pos = [0, 0]
  end

  def build_grid
    @board.rows.map.with_index do |row, i|
      build_row(row, i)
    end
  end

  def build_row(row, i)
    row.map.with_index do |piece, j|
      color_options1 = colors_for1(i, j)
      color_options2 = colors_for2(i, j)
      if piece.color == "white"
        piece.value.to_s.colorize(color_options1)
      else
        piece.value.to_s.colorize(color_options2)
      end
    end
  end


  def colors_for1(i, j)
    if [i, j] == @cursor_pos
      bg = :light_red
    elsif (i + j).odd?
      bg = :gray
    else
      bg = :white
    end
    { background: bg, color: :light_white }
  end

  def colors_for2(i, j)
    if [i, j] == @cursor_pos
      bg = :light_red
    elsif (i + j).odd?
      bg = :gray
    else
      bg = :white
    end
    { background: bg, color: :black }
  end

  def render
    system("clear")
    puts "Arrow keys, WASD, or vim to move, space or enter to confirm."
    build_grid.each { |row| puts row.join }
  end

end
