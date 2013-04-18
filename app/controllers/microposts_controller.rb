class MicropostsController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy, :index]
  before_action :correct_user,   only: :destroy

  def index
    @micropost = current_user.microposts.build
    if params[:tag]
      @feed_items = Micropost.tagged_with(params[:tag]).paginate(page: params[:page])
    else
      @feed_items = Micropost.all.paginate(page: params[:page])
    end
  end

  def create
    @micropost = current_user.microposts.build(micropost_params)

    # Find the reply to in the content and set the in_reply_to to their id
    reply = @micropost.content.match(/\A@\w{6,20}\s/)
    # If they used a valid username at the start of a post
    if(reply)
      # Remove the @ symbol and trailing space
      name = reply[0].gsub(/[@|\s]+/,"")
      user = User.find_by(username: name)
      # If they gave us a valid user set the in_reply_to
      if(user)
        @micropost.in_reply_to = user.id
      end
    end
    # End adding reply to micropost

    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    redirect_to root_url
  end
  
  private

    def micropost_params
      params.require(:micropost).permit(:content,:tag_list)
    end

    def correct_user
      @micropost = current_user.microposts.find(params[:id])
    rescue
      redirect_to root_url
    end
end