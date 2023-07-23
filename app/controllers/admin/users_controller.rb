# frozen_string_literal: true

module Admin
  class UsersController < Admin::AdminController
    before_action :set_user, only: %i[show edit update destroy]

    def index
      authorize! :read, User

      @users = User.includes(:roles)
                   .where.not(id: current_user)
                   .filtered(params[:role_id], params[:email])
                   .paginate(page: params[:page], per_page: 10)
    end

    def new
      authorize! :create, User
      @user = User.new
    end

    def edit
      authorize! :create, @user
    end

    def create
      authorize! :create, User
      @user = User.new(user_params)

      if @user.save
        redirect_to admin_users_url, notice: 'User was successfully created.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      authorize! :create, @user
      required_params = user_params.except(:password) if user_params[:password].blank?

      if @user.update(required_params)
        redirect_to admin_users_url, notice: 'User was successfully updated.'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      authorize! :destroy, @user

      @user.destroy

      redirect_to admin_users_url, notice: 'User was successfully destroyed.'
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:email, :password, :role_ids)
    end
  end
end
