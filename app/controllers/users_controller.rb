class UsersController < ApplicationController
  before_action :signed_in_user,  
                only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user,    only: [:edit, :update]
  before_action :admin_user,      only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

	def show
		@user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
	end
  	
  def new
  	@user = User.new
  end

  def create
    @user = User.new(user_params)
      if @user.save
        sign_in @user
        flash[:success] = "Welcome to the Sample App Yo!"
        redirect_to @user
      else
        render 'new'
      end
  end

  def edit
  end

  def update
    # Make sure you don't try to save to someone else's username or email
    if test_email_username?
      if @user.update_attributes(user_params)
        flash[:success] = "Profile updated"
        sign_in @user
        redirect_to @user
      else
        render 'edit'
      end
    else
      render 'edit'
    end
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  private

    def user_params
      params.require(:user).permit(:name, :username,:email, :password,
                                   :password_confirmation,:nameshow)
    end

    # Find out if either entered email or username is already
    #   in use.
    def test_email_username?
      # get the user by the supplied email
      here = true
      found = User.find_by(email: params[:email])
      # If it's not nil and not equal to current user
      if ( !found.nil? && !@user.equal(found))
        # Someone already has that email
        flash[:error] = "Email already in use"
        here = false
      end
      # get the user by the supplied username
      found  = User.find_by(username: params[:username])
      # If it's not nil and not equal to current user
      if ( !found.nil? && !@user.equal(found))
        flash[:error] = "Username already in use"
        here = false
      end
      # Since username and email aren't currently being used
      return here
    end

    # Before filters

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
