class PasswordResetsController < ApplicationController
  before_action :find_user, :valid_user, :check_expiration,
                only: %i(edit update)

  def new; end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "email_reset_pass"
      redirect_to root_url
    else
      flash.now[:danger] = t "email_not_found"
      render :new
    end
  end

  def update
    if params[:user][:password].blank?
      @user.errors.add(:password, t("cant_be_empty"))
      render :edit
    elsif @user.update user_params
      log_in @user
      flash[:success] = t "pass_has_been_rs"
      redirect_to @user
    end
  end

  def edit; end

  private

  def find_user
    @user = User.find_by email: params[:email]
    return if @user

    flash[:danger] = t "user_not_found"
    redirect_to root_path
  end

  def valid_user
    return if @user.activated? && @user.authenticated?(:reset,
                                                       params[:id])

    flash[:danger] = t "user_not_valid"
    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t "pass_rs_expired"
    redirect_to new_password_reset_url
  end

  def user_params
    params.require(:user).permit(User::PASSWORD_RESET_ATTRS)
  end
end
