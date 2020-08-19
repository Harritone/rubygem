class UsersController < ApplicationController
  before_action :set_user, except: [:index]
  before_action :perform_authorization, only: [:edit, :update]

  def index
    @q = User.ransack(params[:q])
    @users = @q.result(distinct: true)
    authorize @users
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to users_path, notice: "Role of  #{@user.email} was successfuly updated"
    else
      render :edit
    end
  end

  def show
  end

  private

  def set_user
    @user = User.friendly.find_by_slug!(params[:id])
  end

  def user_params
    params.require(:user).permit({ role_ids: [] })
  end

  def perform_authorization
    authorize @user
  end
end
