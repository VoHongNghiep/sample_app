class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :find_user_by_followed_id, only: :create
  before_action :find_relationship_by_id, only: :destroy

  def create
    current_user.follow @user
    respond_to :js
  end

  def destroy
    current_user.unfollow @user
    respond_to :js
  end

  private

  def find_user_by_followed_id
    @user = User.find_by id: params[:followed_id]
    return if @user

    flash[:danger] = t "follow_failed"
    redirect_to root_path
  end

  def find_relationship_by_id
    relation_ship = Relationship.find_by id: params[:id]
    @user = relation_ship.followed if relation_ship
    return if @user

    flash[:danger] = t "unfollow_failed"
    redirect_to root_path
  end
end
