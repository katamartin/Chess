require_relative 'piece'

class SteppingPiece < Piece
  def moves
    move_set.select { |move| valid_move?(move) }
  end

  protected
  def move_set
    delta_set.map { |delta| [delta[0] + pos[0], delta[1] + pos[1]] }
  end
end
