module SessionsHelper
  
  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    current_user = user
  end
  
  def current_user=(user)
    @current_user = user
  end
  
  def current_user 
    @current_user ||= user_from_remember_token #the ||= prevents it from hitting db multiple times
  end
  
  def signed_in?
    !current_user.nil? 
  end
  
  def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil
  end
  
  def deny_access
    redirect_to signin_path, :notice => "Please Sign In To Access This Page!"
  end
  
  
  private
    def user_from_remember_token
      User.authenticate_with_salt(*remember_token) #the * unwraps the array ('1 layer'), into multiple arguments before sending to method
    end
    
    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end
  
end

