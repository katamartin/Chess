require_relative 'piece'

class Pawn < Piece
  attr_reader :origin, :heading
  def initialize(board, pos, color)
    super
    @origin = pos
    @heading = pos.first == 1 ? 1 : -1
    @symbol = "♟"
  end

  def moves
    move_set = []
    delta_set.each do |delta|
      move = [pos[0] + delta[0], pos[1] + delta[1]]
      move_set << move if valid_move?(move)
    end
    attack_set.each do |attack|
      move = [pos[0] + attack[0], pos[1] + attack[1]]
      move_set << move if valid_attack?(move)
    end

    move_set
  end

  def valid_attack?(move)
    return false unless board.on_board?(move)
    return false unless !board[move].empty?

    !board.same_color?(color, move)
  end

  def valid_move?(move)
    board.on_board?(move) && board[move].empty?
  end

  def delta_set
    deltas = [[heading, 0]]
    deltas << [heading * 2, 0] if origin == pos
  end

  def attack_set
    [[heading, -1], [heading, 1]]
  end

end
