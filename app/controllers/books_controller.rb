class BooksController < ApplicationController
  before_action :authenticate_user!

  def show
    @book = Book.find(params[:id]) # Tìm sách theo ID được truyền trong params
    @reviews = @book.reviews # Lấy tất cả reviews cho sách này
  end

  def destroy
    @user = current_user.followers
    @book = Book.find(params[:id])
    if @book.destroy
      if @user.present?
        @user.each do |user|
          Notification.create!(
              user: current_user,
              notifiable: user,
              action_type: "deleted #{@book.title}"
            )

          time = Notification.order(created_at: :desc).find_by(user_id: current_user.id)

          delete_book_notification = { email: current_user.email, action_type: "deleted #{@book.title}", created_at: time.created_at.in_time_zone("Asia/Ho_Chi_Minh").to_formatted_s(:long) }
          UserNotificationChannel.broadcast_to(user, delete_book_notification)
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
    @user = current_user.followers
    @book = Book.new(book_params)
    @book.save
    if @user.present?
      @user.each do |user|
        Notification.create!(
            user: current_user,
            notifiable: user,
            action_type: "created #{@book.title}"
          )

          time = Notification.order(created_at: :desc).find_by(user_id: current_user.id)

        create_book_notification = { email: current_user.email, action_type: "created #{@book.title}", created_at: time.created_at.in_time_zone("Asia/Ho_Chi_Minh").to_formatted_s(:long) }
        UserNotificationChannel.broadcast_to(user, create_book_notification)
        end
    end

    redirect_to root_path, alert: 'Create book successfully'
  end

  private

  def book_params
    params.require(:book).permit(:title, :content)
  end
end
