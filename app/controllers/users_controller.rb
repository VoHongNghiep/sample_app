class UsersController < ApplicationController
  before_action :find_user, except: %i(index new create)
  before_action :logged_in_user, except: %i(show new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @pagy, @users = pagy User.all, items: Settings.max_page
  end

  def new
    @user = User.new
  end

  def show
    @pagy, @microposts = pagy @user.microposts, items: Settings.max_page
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "check_active_email"
      redirect_to @user
    else
      flash[:danger] = t "user_not_save"
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "update_success"
      redirect_to @user
    else
      flash[:danger] = t "update_fail"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "delete_success"
    else
      flash[:danger] = t "delete_fail"
    end
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit(User::USER_ATTRS)
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t ".login_message"
    redirect_to login_url
  end

  def correct_user
    redirect_to root_url unless @user == current_user
  end

  def admin_user
    return if current_user.admin?

    flash[:danger] = t "alert_admin_user"
    redirect_to root_url
  end

  def find_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "user_not_found"
    redirect_to root_path
  end
end
