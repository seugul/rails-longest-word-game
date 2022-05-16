require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = (0...10).map { ('a'..'z').to_a[rand(26)] }
  end

  def included?(attempt, array)
    attempt = attempt.upcase
    attempt.chars.all? do |lettre|
      attempt.count(lettre) <= array.count(lettre)
    end
  end

  def score
    url = "https://wagon-dictionary.herokuapp.com/#{params[:word]}"
    user_serialized = URI.open(url).read
    word = JSON.parse(user_serialized)
    @result = word['found']
    @letters = params[:letters].upcase
    if @result == true && included?(params[:word], @letters) == true
      @message = "Congratulations #{params[:word].upcase} is a valid English word!"
    elsif included?(params[:word], @letters) == true
      @message = "Sorry but #{params[:word].upcase} doesn't seem to be a valid English word!"
    else
      @message = "Sorry but #{params[:word].upcase} can't be built out of #{@letters}"
    end
  end
end
