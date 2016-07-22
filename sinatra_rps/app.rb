#app.rb

require 'sinatra'
require 'pry-byebug'

get '/choice' do
  erb :choice
end

post '/choice' do
  user_choice = params[:option]
  computer_choice = ["rock", "paper", "scissors"].sample
  result = compare_choices(user_choice, computer_choice)

  if result == 1
    erb :win, locals: {user: user_choice, computer: computer_choice, user_image: get_image(user_choice), computer_image: get_image(computer_choice)}
  elsif result == -1
    erb :lose, locals: {user: user_choice, computer: computer_choice, user_image: get_image(user_choice), computer_image: get_image(computer_choice)}
  else
    erb :tie, locals: {user: user_choice, computer: computer_choice, user_image: get_image(user_choice), computer_image: get_image(computer_choice)}
  end
end 

def compare_choices(user, computer)
   winners = { "rock" => "scissors", 
                      "paper" => "rock", 
                      "scissors" => "paper"   }
  if winners[user] == computer
    return 1
  elsif winners[computer] == user
    return -1
  else
    return 0
  end
end

def get_image(choice)
  images = {"rock" => "https://i.ytimg.com/vi/cRnE9j9SzMU/maxresdefault.jpg",
            "paper" => "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcTrqJW41HzsoVavrtVbokAiJ_cJdbyZqcBADtJnOctCJso3LRAYRw",
            "scissors" => "http://38.media.tumblr.com/15216eda2e8af7795786b339b7ebdd26/tumblr_nbyrv9LSCB1rp0vkjo1_500.gif"
  }

  images[choice]
end


