def login_user(user)
  session[:user_id] = user.id
  @current_user = user
end