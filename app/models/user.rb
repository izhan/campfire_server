class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  # TODO do we need all of this?
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
