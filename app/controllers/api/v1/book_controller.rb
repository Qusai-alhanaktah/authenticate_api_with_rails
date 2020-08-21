class Api::V1::BookController < ApplicationController
before_action :load_book, only: :show

  def index
    @books = Book.all
    render_response "You get all books Successfully", true, {books: @books}, :ok
  end

  def show
    render_response "You get the book Successfully", true, {book: @book}, :ok
  end

  def load_book
    @book = Book.find_by id:params[:id]
    unless @book.present?
      render_response "You Can not get book", false, {}, :not_found
    end
  end

end
