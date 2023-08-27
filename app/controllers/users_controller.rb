class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update,]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
  end

  def index
    @users = User.all
    @book = Book.new
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
  # def update
  #   if @user.update(user_params)
  #     redirect_to users_path(@user), notice: "You have updated user successfully."

  #   else
  #     render "show"
  #   end
  # end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
