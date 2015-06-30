require_relative 'sliding_piece'

class Rook < SlidingPiece

  def initialize(board, pos, color)
    super
    @symbol = "♜"
  end

  def move_dirs
    CART_DELTAS
  end
end
