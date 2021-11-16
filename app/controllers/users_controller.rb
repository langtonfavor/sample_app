class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                        :following, :followers]
  before_action :correct_user, only: [:edit, :update, :destroy, :show]

  def index
    @user = User.paginate(page: params[:page])
  end

  def show
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
  end


  def update
    if @user.update_attributes(user_params)
      flash[:success] = "profile updated"
      redirect_to @user
    else
      flash[:danger] = "update failed"
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = "user deleted"
      redirect_to user_url
    else
      flash[:danger] = "could not peform the operation"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless @user == current_user
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
    end
  def logged_in_user
    unless logged_in?
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end
end
