class UsersController < ApplicationController
    before_action :authenticate_user!

    def index
        @users = User.where.not(id: current_user.id)
        # @notifications = Notification.where(notifiable_id: current_user.id).joins(:user).select("")
        @notifications = Notification.joins(:user).where(notifiable_id: current_user.id).select('notifications.*, users.email AS email').map do |notification|
            {
                id: notification.id,
                user_id: notification.user_id,
                notifiable_type: notification.notifiable_type,
                notifiable_id: notification.notifiable_id,
                action_type: notification.action_type,
                created_at: notification.created_at,
                updated_at: notification.updated_at,
                email: notification.email,
                message: "#{notification.email} đã #{notification.action_type}"
            }
        end
    end

    def show
        @user = User.find(params[:id])
    end

    def destroy
        @user = User.find(params[:id])
        @user.destroy
        redirect_to root_path, notice: 'User deleted successfully'
    end
end
