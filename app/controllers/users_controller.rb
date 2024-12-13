class UsersController < ApplicationController
    before_action :authenticate_user!

    def index
        @users = User.where.not(id: current_user.id)
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
