module SaveLoad
  def save_game(board_array, game_stats)
    print 'Enter a name to save your file: '
    keyword = gets.chomp
    fen_code = board_to_fen(board_array, game_stats)
    yaml = YAML.dump(fen_code)
    file = File.new("#{keyword}.yaml", 'w')
    file.write(yaml)
    exit
  end

  def board_to_fen(board_array, game_stats)
    simpler_array = piece_to_char(board_array)
    simpler_array = simpler_array.map do |rank|
      concat_row(rank)
    end.join('/')
    simpler_array.concat(' ', concat_stats(game_stats))
  end

  def concat_stats(game_stats)
    stats_array = [game_stats[:turn][0], [game_stats[:castle][:white][:king_side], game_stats[:castle][:white][:queen_side],
                                          game_stats[:castle][:black][:king_side], game_stats[:castle][:black][:queen_side]],
                   game_stats[:en_passant][:algebraic], game_stats[:half_moves], game_stats[:full_moves]]
    stats_array[1] = stats_array[1].compact.join
    stats_array[1] = '-' if stats_array[1] == ''
    stats_array.join(' ')
  end

  def piece_to_char(board_array)
    board_array.map do |rank|
      rank.map do |piece|
        piece ? piece.fen_initial : 1
      end
    end
  end

  def concat_row(array)
    array.inject('') do |r, v|
      if v.is_a?(Integer) && r[-1].to_i == 0
        r.concat(v.to_s)
      elsif v.is_a?(Integer) && r[-1].to_i != 0
        r[0..-2].concat((r[-1].to_i + v).to_s)
      else
        r.concat(v)
      end
    end
  end
end
