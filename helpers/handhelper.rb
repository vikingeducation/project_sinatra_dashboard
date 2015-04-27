module HandHelper

  def value_of_hand(cards)
    sum = 0
    cards.each { |card| sum += value_of_card(card, sum) }
    return sum
  end

  def value_of_card(card, sum)
    if [:J, :K, :Q].include?(card)
      return 10
    elsif card == :A
      return 1 if sum + 11 > 21
      return 11 if sum + 11 <= 21
    else
      return card
    end
  end

  def dealer_blackjack?
    value_of_hand(session[:dealer_hand]) == 21
  end

  def player_blackjack?
    value_of_hand(session[:player_hand]) == 21
  end

  def player_bust?
    value_of_hand(session[:player_hand]) > 21
  end

  def dealer_bust?
    value_of_hand(session[:dealer_hand]) > 21
  end

  def result_conditions
    if player_bust?
      "<p>You bust, you lost!</p>"
    elsif dealer_bust?
      "<p>The dealer bust! You won!</p>"
    elsif value_of_hand(session[:player_hand]) > value_of_hand(session[:dealer_hand])
      "<p>You beat the dealer's hand! You won!</p>"
    elsif value_of_hand(session[:player_hand]) == value_of_hand(session[:dealer_hand])
      "<p>It's a draw!</p>"
    else
      "<p>You lost!</p>"
    end
  end

end