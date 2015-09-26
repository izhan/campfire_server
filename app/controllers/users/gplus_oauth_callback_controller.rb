class Users::GplusOauthCallbackController < ApplicationController
  def callback
    puts "in callback"
    puts params
    puts params[:code]
  end
end