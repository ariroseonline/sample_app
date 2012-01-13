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
      sign_in user
      redirect_back_or user
    end
  end
  
  def destroy
    sign_out
    redirect_to root_path
  end

end
