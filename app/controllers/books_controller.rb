class BooksController < ApplicationController
  def show
    @book = Book.find(params[:id]) # Tìm sách theo ID được truyền trong params
    @reviews = @book.reviews # Lấy tất cả reviews cho sách này
  end

  def destroy
    @book = Book.find(params[:id])
    if @book.destroy
      redirect_to root_path, alert: 'Book deleted successfully'
    else
      redirect_to root_path, alert: 'Book not found'
    end
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.save
    redirect_to root_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :content)
  end
end
