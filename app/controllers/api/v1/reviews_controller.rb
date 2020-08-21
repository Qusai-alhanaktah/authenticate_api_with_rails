class Api::V1::ReviewsController < ApplicationController
  before_action :load_book, only: :index
  before_action :load_review, only: [:show, :update, :destroy]
  before_action :authenticate_with_token!, only: :create

  def index
    @reviews = @book.reviews
    render_response "You get all review Successfully", true, {review: @reviews}, :ok
  end

  def show
    render_response "You get all review Successfully", true, {review: @review}, :ok
  end

  def create
    @review = Review.new review_params
    @review.user_id = current_user.id
    @review.book_id = params[:book_id]

    if @review.save
      render_response "You create review Successfully", true, {review: @review}, :ok
    else
      render_response "You can not create review", false, {}, :not_found
    end
  end
  def update
    if valid_user @review.user
      if @review.update review_params
        render_response "You update review Successfully", true, {review: @review}, :ok
      else
        render_response " did not update review", false, {}, :unprocessable_entity
      end
    else
      render_response "You can not update review", false, {}, :unauthorized
    end
  end
  def destroy
    if valid_user @review.user
      if @review.destroy
        render_response "You delete review Successfully", true, {}, :ok
      else
        render_response " did not delete review", false, {}, :unprocessable_entity
      end
    else
      render_response "You can not delete review", false, {}, :unauthorized
    end
  end

  private
  def load_book
    @book = Book.find_by id: params[:book_id]
    unless @book.present?
      render_response "You can not get this book", false, {}, :not_found
    end
  end

  private
  def load_review
    @review = Review.find_by id: params[:id]
    unless @review.present?
      render_response "You can not get this review", false, {}, :not_found
    end
  end

  private
  def review_params
    params.require(:review).permit(:title, :current_rating, :recommend_rating)
  end
end
