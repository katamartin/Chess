require_relative 'board'
require_relative 'human_player'

class Game
  attr_reader :board, :players
  def initialize
    @board = Board.new
    @players = [HumanPlayer.new(@board, :white), HumanPlayer.new(@board, :black)]
  end

  def play
    until win?
      player = players.first
      board.render
      puts "#{player.color.to_s.capitalize}, it's your turn!"
      player.play_turn
      switch_players
    end
    losing_message
  end

  def switch_players
    players.rotate!
  end

  def win?
    board.checkmate?(players.first.color)
  end

  def losing_message
    puts "Checkmate, #{players.first.color.to_s.capitalize} loses!"
  end
end
