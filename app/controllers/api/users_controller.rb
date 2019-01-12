class Api::UsersController < ApplicationController

  before_action :verify_jwt_token, only: [:changePassword]

  def index
    @users = User.all
  end

  #Sign up new user
  def create
    @user = User.new(user_params)
    if @user.save
      render :ok, json: {}
    else
      @errors = @user.errors.full_messages
      render json: { message: @errors }, status: :unauthorized
    end
  end

  def update
  end

  def changePassword
    @user = User.find_by(email: params[:email])
    @user.password = params[:password]
    @user.save()
    if @user.save
      render :ok, json: {}
    else
      @errors = @user.errors.full_messages
      render json: { message: @errors }, status: :unprocessable_entity
    end
  end


  #Handle both deleting account and only removing user from team
  def destroy
    @team = Team.find(params[:team_id])
    if @team
      #Only delete from team
      @user = User.find(params[:id])
      @team.users.delete(@user)
    else
      #Delete account
      @user.destroy
    end
  end


  private

  def user_params
    params.permit(:username, :email, :password)
  end

end
