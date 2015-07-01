require_relative 'board'
require_relative 'human_player'
require_relative 'computer_player'

class Game
  def initialize
    @board = Board.new
    @players = [HumanPlayer.new(@board, :white), ComputerPlayer.new(@board, :black)]
  end

  def play
    until win?
      player = players.first
      board.render(player.color)
      puts "#{player.color.to_s.capitalize}, it's your turn!"
      player.play_turn
      switch_players
    end
    losing_message
  end

  private
  def switch_players
    players.rotate!
  end

  def win?
    board.checkmate?(players.first.color)
  end

  def losing_message
    puts "Checkmate, #{players.first.color.to_s.capitalize} loses!"
  end

  attr_reader :board, :players
end
