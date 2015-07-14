# quiz.rb

# QUIZ: reverse words in place

# I.e:

# "Hi my name is Michael"
# ==> "Michael is name my Hi"

# def reverse(words)

#   reverse = []

#   words = words.scan(/\w+/)

#   words.each do |word|
#     reverse.unshift(word)
#   end

#   reverse

# end



def reverse(words)

  initial_length = words.length
  new_stop = initial_length - 1

  (initial_length-1).downto(0) do |index|
    if words[index] == " "
      words += words[index..new_stop]
      new_stop = index - 1
    elsif index == 0
      words += " #{words[index..new_stop]}"
    end
  end

  words[initial_length+1..-1]

end

puts reverse("Hi my name is Michael")