class User < ApplicationRecord
  has_secure_password
  validates_presence_of :name,:email,:password_digest
  validates_uniqueness_of :email
  validates :name, :presence=>true
  validates_format_of :email,:with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/,:presence =>true
  # validates :phone,:presence=> true,
  #           :numericality=>true,
  #           :length=>10
  validates :counter,:presence=>true,:numericality => {:greater_than_or_equal_to => 0}
end
