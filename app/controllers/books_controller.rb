class BooksController < ApplicationController
	before_action :authenticate_user!
  before_action :correct_user, only: [:edit, :update]

  def index
  	@books = Book.all
  	@book = Book.new
    @favorite = Favorite.new
  end

  def create
  	@book = Book.new(book_params)
  	@book.user_id = current_user.id
  	if @book.save
      flash[:notice] = "You have creatad book successfully."
  	  redirect_to book_path(@book)
    else
      @books = Book.all
      render "books/index"
    end
  end

  def show
  	@book = Book.find(params[:id])
    @favorite = Favorite.new
    @comments = @book.comments
    @comment = @book.comments.build
  end

  def edit
  end

  def update
    if @book.update(book_params)
      flash[:notice] = "You have updated book successfully."
      redirect_to book_path(@book)
    else
      render "books/edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
  	params.require(:book).permit(:title,:body)
  end

  def correct_user
    @book = Book.find(params[:id])
      redirect_to books_path unless @book.user == current_user
  end

end
