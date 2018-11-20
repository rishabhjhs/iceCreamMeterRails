class AuthenticateUser
  prepend SimpleCommand

  def initialize(email)
    @email = email
  end

  def call
    JsonWebToken.encode(username: @email)
  end

  private
  attr_accessor :email, :password
end