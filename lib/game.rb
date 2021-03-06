class Game # Humans
  attr_accessor :board, :player_1, :player_2

  # defaults to two human players, X and O, with an empty board
  def initialize(player_1=Players::Human.new("X"), player_2=Players::Human.new("O"), board = Board.new)
    @player_1 = player_1
    @player_2 = player_2
    @board = board
  end

  WIN_COMBINATIONS =[
        [0,1,2],
        [3,4,5],
        [6,7,8],
        [0,3,6],
        [1,4,7],
        [2,5,8],
        [0,4,8],
        [6,4,2]
  ]

  # checks who the current player is
  def current_player
    counter = 0
    board.cells.each do | occ_pos |
      if  occ_pos == "X" ||  occ_pos =="O"
        counter+=1
      end
    end
    counter
    if counter % 2 == 0
      player_1 # these were defined in the init method with the values player_1 == X and player_2 == O
    else
      player_2
    end
  end

  def over?
    won? || draw?
  end

  # makes valid moves, changes to playe 2 after the first turn and calls on turn again if failed validation
  def turn
    puts "Please enter 1-9:"
    # Because the tests are checking to see if you call move once,
    # they will flag an error if you call it twice, and it
    # save it under a different name current_move
    current_move = current_player.move(board)
    # if player makes an invalid move then turn starts over
    if !board.valid_move?(current_move)
      puts "Sorry that is invalid"
      turn
    end
      puts "Please enter 1-9:"
      # updates the cells in the board with the player token according to the input
      board.update(current_move, current_player)
      # binding.pry
      board.display
  end

# +++++++++++++++++++++++++++++++++++++++++ Helper Methods +++++++++++++++++++++++++++++++++++++++++++++++++++

  # helper method for over?
  def won?
    WIN_COMBINATIONS.detect do | win_comb |
      win_index_1 = win_comb[0]
      win_index_2 = win_comb[1]
      win_index_3 = win_comb[2]
      position_1 = board.cells[win_index_1]
      position_2 = board.cells[win_index_2]
      position_3 = board.cells[win_index_3]
      if position_1 ==  position_2 && position_2 ==  position_3 && position_1 != " "
         win_comb # return the win_combination indexes that won.
      else
        false
      end
    end
  end

  # helper method for over?
  def draw?
    !won? && full?
  end

  # helper method for draw?
  def full?
    board.cells.none? do | position |
      position == " "
    end
  end

  # The winner method should return the token, "X" or "O" that has won the game given a winning board.
  def winner
    win_combination = won?
    if win_combination
      win_index = win_combination[0]
      wining_token = board.cells[win_index]
      wining_token
      # puts "#{wining_token} is the winner!"
    end
  end

  # asks for players input on a turn of the game
  def play
    while !over?
      turn
    end
    if won?
      puts "Congratulations #{winner}!"
    elsif draw?
      puts "Cats Game!"
    end
  end

  def begin
    input=""
    invalid = "Invalid!"
    comp_vs_comp = "wargames"
    hum_vs_comp = "single player"
    hum_vs_hum = "two player"
    introduction
    until input == "exit"
      input = gets.strip.downcase
      case input
      # computer vs computer config
      when comp_vs_comp
        game = Game.new(player_1= Players::Computer.new("X"), player_2=Players::Computer.new("O"), board = Board.new)
        count = 0
        100.times do
          if game.won?
            count +=1
          end
          game.play
        end
        puts "Game won #{count} times!"
      # human vs human config
      when hum_vs_hum
        puts "X goes first"
        game = Game.new
        game.play
      # human vs computer config
      when hum_vs_comp
        game = Game.new(player_1= Players::Human.new("X"), player_2=Players::Computer.new("O"), board = Board.new)
        game.play
      when 'exit'
        puts 'Game Over.'
      else
      puts invalid
      end
      if input !='exit' && (game.won? || game.over? || game.draw? || game.full?)
        puts "To start over choose any of the options again."
        puts "1. wargames - for Computer vs Computer"
        puts "2. single player - for Single Player mode"
        puts "3. two player - for Two Player mode"
      end
    end
  end

  def introduction
      puts "Welcome to Tic Tac Toe"
      puts "Which game do you want to play?"
      puts "1. wargames - for Computer vs Computer"
      puts "2. single player - for Single Player mode"
      puts "3. two player - for Two Player mode"
  end

end
