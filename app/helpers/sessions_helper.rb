module SessionsHelper
  def sign_in(user)
  	# create new remember_token
    remember_token = User.new_remember_token
    #store the new remember_token in cookie. We have this in order to retrieve the
    #token when the user moves to subsequent pages. Since HTTP is
    #stateless everything is loss and in order to know what the user
    #is we have to retrieve this token and again find the current user
    #with this token
    cookies.permanent[:remember_token] = remember_token 
    #update the user's remember token to a new one
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    # we save the user in an instanvce variable called current_user.
    self.current_user=(user)
  end

  def current_user=(user)
    @current_user = user
  end

# the purpose of this method is for use in controller and views. We want to be able to grab
# the current_user for the particular session. 
def current_user
  	# get the remember token from the browser. We do this so we identify the current user.
  	# We also need to encrypt it because it was encrypted in the database
    remember_token = User.encrypt(cookies[:remember_token])

    #find_by is only called once when @current_user is nil. Once it
    #has the value of the current_user it will just be the
    #value. Therefore, it only searches through the database once.
    # @current_user = @current_user ||  User.find_by(remember_token: remember_token)
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  def current_user?(user)
    user == current_user
  end

  # if the current_user is not nil, that means he is signed in
  def signed_in?
    !current_user.nil?
  end

  def sign_out
    # create a new remember token for the user (for next time)
    current_user.update_attribute(:remember_token,
      User.encrypt(User.new_remember_token))
    # delete the cookie
    cookies.delete(:remember_token)
    # set the user to nil
    self.current_user = nil
  end

  def redirect_back_or(default)
    # redirect to the saved session
    redirect_to(session[:return_to] || default)
    # important to delete this because 
    session.delete(:return_to)
  end

  def store_location
    # stores the requested url, but only for GET requests. Wouldn't want to be
    # submitting a form as the saved url
    session[:return_to] = request.url if request.get?
  end

end
