class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build micropost_params
    @micropost.image.attach params[:micropost][:image]
    if @micropost.save
      flash[:success] = t "micropost_create"
      redirect_to root_url
    else
      @pagy, @feed_items = pagy current_user.feed
      render :root
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t "micropost_delete"
    else
      flash[:danger] = t "micropost_delete_fail"
    end
    redirect_to request.referer || root_url
  end

  private

  def micropost_params
    params.require(:micropost).permit Micropost::CREATEABLE_ATTR
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    return if @micropost

    flash[:danger] = t "empty_micropost"
    redirect_to root_url
  end
end
