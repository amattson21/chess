require 'byebug'
require_relative 'humanplayer.rb'
require_relative 'computerplayer.rb'
require_relative 'board.rb'
require_relative 'display.rb'

class Chess

  def initialize
    @board = Board.new
    @display = Display.new(@board)
    @players = set_players
    @current_player = @players[0]
  end

  def play
    until @board.check_mate?(@current_player.color)
      make_move
    end
    # loop do
    #   make_move
    # end
    @display.render(@current_player.color)
    puts "#{@current_player.name} won!"
  end

  private

  def set_players
    puts "Choose game type"
    puts "1 - Human vs Human"
    puts "2 - Human vs Computer"
    puts "3 - Computer vs Computer"
    case gets.chomp
    when "1"
      @players = [HumanPlayer.new("jeff",:white,@display), HumanPlayer.new("Alex", :black,@display)]
    when "2"
      @players = [HumanPlayer.new("jeff",:white,@display), ComputerPlayer.new("Alex", :black,@display)]
    when "3"
      @players = [ComputerPlayer.new("jeff",:white,@display), ComputerPlayer.new("Alex", :black,@display)]
    end
  end

  #handle move
  def make_move
    loop do
      @display.render(@current_player.color)
      unless @current_player.get_action(@display).nil? # this is checking for return key
        break
      end
    end
    @display.select_piece
    loop do
      @display.render(@current_player.color)
      unless @current_player.get_action(@display).nil? # this is checking for return key
        move_to
        break
      end
    end
    swap_turn!
  rescue StandardError => e
    puts e
    sleep 0.5
    @display.reset!
    retry
  end

  def move_to
    start = @display.selected
    finish = @display.cursor_pos
    return @board.move_piece(start, finish, @current_player.color)
  end

  #handle turn
  def swap_turn!
    @display.selected = nil
    @current_player = @current_player == @players[0] ? @players[1] : @players[0]
  end

end

Chess.new.play
