class BooksController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update]
  def show
    @room = Room.new
    @book_detail = Book.find(params[:id])
    unless ViewCount.find_by(user_id: current_user.id, book_id: @book_detail.id)
      current_user.view_counts.create(book_id: @book_detail.id)
    end

    @book = Book.find(params[:id])
    #閲覧数のカウントを１つの投稿に付き1人の１日１回まで数える方法
    #unless ViewCount.where(created_at: Time.zone.now.all_day).find_by(user_id: current_user.id, book_id: @book.id)
      #current_user.read_counts.create(book_id: @book.id)
    #end

    @user = User.find_by(id: @book.user_id)#投稿でユーザー情報の表示をする
    @Book = Book.new#@Bookにbookの空を代入、books/showのrender 'form'に空の値が入るようになっている。
    @book_comment = BookComment.new
  end

  def index
    to = Time.current.at_end_of_day
    from = (to - 6.day).at_beginning_of_day
    @books = Book.includes(:favorited_users).
      sort_by {|x|
        x.favorited_users.includes(:favorites).where(created_at: from...to).size
      }.reverse
    @book = Book.new
    @user = current_user#いらなくないか
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
    flash[:notice] = "You have created book successfully."
    redirect_to book_path(@book.id)
    else
    @user = current_user#いらなくないか
    render :index
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
    flash[:notice] = "You have updated book successfully."
    redirect_to book_path(@book.id)
    else
      render :edit
    end
  end


  def destroy
    book = Book.find(params[:id])
    book.destroy
    redirect_to '/books'
  end

  private

  def book_params
    params.require(:book).permit(:title, :body, :image, :star)#ここのstar
  end

 def is_matching_login_user
   book =Book.find(params[:id])
  unless book.user.id == current_user.id
    redirect_to books_path
  end
 end
end