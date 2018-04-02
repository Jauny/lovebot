class WelcomeController < ApplicationController
  def index
    @tweets = [1, 2, 3, 4]
  end
end
