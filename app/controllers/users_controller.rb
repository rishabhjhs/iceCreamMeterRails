class UsersController < ApplicationController
  skip_before_action :only => [:create, :authenticate, :authenticate_user_token]

  before_action :only => [:authenticate, :authenticate_user_token]

  def index
    @user = User.all
    render :json => {:users => @user}
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render :json => {:error => 0, :success => 1, :body => @user}
    else
      render :json => {:error => 1, :success => 0, :body => @user.errors}
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update_counter

    @user = User.find(params[:id])
    new_counter = params[:counter]
    if (new_counter.to_i >= 0)
      @user.update_column(:counter, new_counter)
      render :json => {:body => @user}
      return
    end
    render :json => {:error => "You cannot update with negative value"}

  end

  def redeem
    @user = User.find(params[:id])
    if (@user.counter >= 5)
      @user.update_column(:counter, @user.counter - 5)
      render :json => {:remainingCount => @user.counter}
      return
    end
    render :json => {:message => "You cannot redeem your points"}

  end


  def update
    @user = User.find(params[:id])
    if @user.update(update_params)
      render :json => {:body => @user}
      return
    end
    render :json => {:error => "email already exist"}
  end

  def show
    @user = User.find(params[:id])
    render :json => {:body => @user}
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    if @user.destroyed?
      render :json => {:body => User.all}
    end
  end

  def authenticate_user_token
    @@current_user = AuthorizeApiRequest.call(request.headers).result
    respond_to_login = false
    respond_to_login = {name: @@current_user["name"], email: @@current_user.email, counter: @@current_user.counter, id: @@current_user.id, auth_token: request.headers['Authorization'].split(' ').last} if @@current_user
    render respond_to_login, json: respond_to_login
  end

  def authenticate
    @@current_user = User.find_by_email(params[:email])
    render false, json: false and return if @@current_user == nil
    if @@current_user.authenticate(params[:password])
      jwt_auth_token = AuthenticateUser.call(@@current_user.email)
      render json: {auth_token: jwt_auth_token.result}, status: :ok
      return
    end
    render json: {error: auth_token.errors}, status: :unauthorized
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :phone, :counter)

  end

  def update_params
    params.require(:user).permit(:name, :email, :password, :phone)
  end
end





