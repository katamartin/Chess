require_relative 'pieces'
require_relative 'empty_square'
class Board
  attr_reader :grid
  def initialize
    @grid = Array.new(8) { Array.new(8) { EmptySquare.new } }
  end

  def [](pos)
    x, y = pos
    grid[x][y]
  end

  def []=(pos, value)
    x, y = pos
    grid[x][y] = value
  end

  def valid_move?(color, pos)
    return false unless on_board?(pos)
    return true if board[pos].empty?
    !same_color?(color, pos)
  end

  def on_board?(pos)
    pos.all? { |coord| coord.between?(0, 7) }
  end

  def same_color?(color, pos)
    board[pos].color == color
  end
end
