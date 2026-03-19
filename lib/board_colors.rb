module BoardColors
  COLORS = {
    # Green Board:
    black_square: '23',
    white_square: '35',
    # Blue Board:
    # black_square: '21',
    # white_square: '33',
    # Brown Board:
    # black_square: '88',
    # white_square: '130',
    black_piece: '16',
    white_piece: '15'
  }.freeze

  refine String do
    def white_square
      color_val = COLORS[:white_square]
      "\e[48;5;#{color_val}m#{self}\e[0m"
    end

    def black_square
      color_val = COLORS[:black_square]
      "\e[48;5;#{color_val}m#{self}\e[0m"
    end

    def white_piece
      color_val = COLORS[:white_piece]
      "\e[38;5;#{color_val}m#{self}\e[0m"
    end

    def black_piece
      color_val = COLORS[:black_piece]
      "\e[38;5;#{color_val}m#{self}\e[0m"
    end
  end
end
