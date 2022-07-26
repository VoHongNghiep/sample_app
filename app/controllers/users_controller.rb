class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find_by params[:id]
    return if @user

    flash[:danger] = t "user_not_found"
    redirect_to root_path
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t "welcome_msg"
      redirect_to @user
    else
      flash[:danger] = t "user_not_save"
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(User::USER_ATTRS)
  end
end
