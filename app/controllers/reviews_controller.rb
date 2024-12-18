class ReviewsController < ApplicationController
  def create
    @book = Book.find(params[:book_id])
    @review = @book.reviews.new(review_params)
    users = current_user.followers

    if @review.save
      ActionCable.server.broadcast("book_#{@book.id}_reviews", { review: render_review(@review) })

      if users.present?
        users.each do |user|
          Notification.create!(
            user: current_user,
            notifiable: user,
            action_type: 'review'
          )

          review_notification = { user: current_user.email, action: 'review' }
          ActionCable.server.broadcast("user_#{user.id}_channel", review_notification)
        end
      end

      render json: @review, status: :created
    else
      render json: { error: "Unable to save review" }, status: :unprocessable_entity
    end
  end


  private

  def review_params
    params.require(:review).permit(:content)
  end

  def render_review(review)
    ApplicationController.renderer.render(partial: 'reviews/review', locals: { review: review })
  end
end
