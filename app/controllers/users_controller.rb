class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update,]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
    @following_users = @user.following_users
    @follower_users = @user.follower_users
  end

  def index
    @users = User.all
    @book = Book.new
    @user = current_user
  end
  def edit
    @user = User.find(params[:id])#要復習
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
    flash[:notice] = "You have updated user successfully."
    redirect_to user_path(@user.id)
    else
      render :edit
    end
  end

  def follows
    user = User.find(params[:id])
    @users = user.following_user.page(params[:page]).per(3).reverse_order
  end

  def followers
    user = User.find(params[:id])
    @users = user.follower_user.page(params[:page]).per(3).reverse_order
  end


    private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user#なんか違う
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
