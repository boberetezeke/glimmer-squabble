class SquareModifier
  START_SQUARE = :start_square
  DOUBLE_LETTER = :double_letter
  TRIPLE_LETTER = :triple_letter
  DOUBLE_WORD = :double_word
  TRIPLE_WORD = :triple_word

  DOUBLES = [DOUBLE_LETTER, DOUBLE_WORD, START_SQUARE]

  LETTER_MODIFIERS = [DOUBLE_LETTER, TRIPLE_LETTER]
  WORD_MODIFIERS = [START_SQUARE, DOUBLE_WORD, TRIPLE_WORD]

  def initialize(modifier)
    @modifier = modifier
  end

  def start_square?
    @modifier == START_SQUARE
  end

  def double_word?
    @modifier == DOUBLE_WORD
  end

  def triple_word?
    @modifier == TRIPLE_WORD
  end

  def for_letter?
    LETTER_MODIFIERS.include?(@modifier)
  end

  def for_word?
    WORD_MODIFIERS.include?(@modifier)
  end

  def modify_score(score)
    if DOUBLES.include?(@modifier)
      score * 2
    else
      score * 3
    end
  end
end