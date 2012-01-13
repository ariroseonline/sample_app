class UsersController < ApplicationController
  before_filter :authenticate, :only => [:edit, :update]
  def show
    @user = User.find(params[:id])
    @title = @user.name
  end
  
  def new
    @title = "Sign Up"
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      @title = "Sign Up"
      render 'new'
    end
  end
  
  def edit
    @user = User.find params[:id]
    @title = "Edit User"
  end
  
  def update
    @user = User.find params[:id]
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile Updated!"
      redirect_to @user
    else
      @title = "Edit User"
      render 'edit'
    end
  end
  
  private
    def authenticate
      deny_access unless signed_in?
    end
    
end
