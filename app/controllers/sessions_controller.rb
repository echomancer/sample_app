class SessionsController < ApplicationController
  def new
  end

  def create
    # First try to find by email then try by username
    user = User.find_by(email: params[:session][:login].downcase)
    if user.nil?
      user = User.find_by(username: params[:session][:login])
    end

    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_back_or user
    else
      flash.now[:error] = 'Invalid login/password combination'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end
