class BooksController < ApplicationController
  def show
    @book = Book.find(params[:id]) # Tìm sách theo ID được truyền trong params
    @reviews = @book.reviews # Lấy tất cả reviews cho sách này
  end

  def destroy
    @book = Book.find(params[:id])
    users = current_user.followers
    if @book.destroy
      if users.present?
        users.each do |user|
          Notification.create!(
              user: current_user,
              notifiable: user,
              action_type: 'delete book'
            )
          delete_book_notification = { user: current_user.email, action: 'delete book' }
          ActionCable.server.broadcast("user_#{current_user.id}_channel", delete_book_notification)
        end
      end
      redirect_to root_path, notice: 'Book deleted successfully'
    else
      redirect_to root_path, notice: 'Book not found'
    end
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    users = current_user.followers
    @book.save
    if users.present?
      users.each do |user|
        Notification.create!(
            user: current_user,
            notifiable: user,
            action_type: 'create book'
          )
        create_book_notification = { user: current_user.email, action: 'create book' }
        ActionCable.server.broadcast("user_#{current_user.id}_channel", create_book_notification)
      end
    end
    redirect_to root_path, alert: 'Create book successfully'
  end

  private

  def book_params
    params.require(:book).permit(:title, :content)
  end
end
