class SessionsController < ApplicationController
  def new
    @title = "Sign In"
  end
  
  def create
    user= User.authenticate(params[:session][:email], params[:session][:password])
    @title = "Sign In"
    if user.nil?
    flash.now[:error] = "Invalid email/password combination."
     render :new
    else
      #handle success
    end
  end
  
  def destroy
  end

end
