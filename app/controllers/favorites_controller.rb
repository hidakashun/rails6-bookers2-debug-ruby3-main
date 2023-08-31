class FavoritesController < ApplicationController

  def create
    book = Book.find(params[:book_id])
    favorite = current_user.favorites.new(book_id: book.id)
    favorite.save

#処理を行う前にいた画面に遷移するにはどうしたらいい？
  end

  def destroy
    book = Book.find(params[:book_id])
    favorite = current_user.favorites.find_by(book_id: book.id)
    favorite.destroy

#処理を行う前にいた画面に遷移するにはどうしたらいい？
  end

end