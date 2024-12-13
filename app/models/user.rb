class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable

  has_many :follows
  has_many :followed_users, through: :follows, source: :followed
  has_many :reverse_follows, class_name: 'Follow', foreign_key: 'followed_id'
  has_many :followers, through: :reverse_follows, source: :user

  def follow(other_user)
    follows.create(followed_id: other_user.id)
  end

  def unfollow(other_user)
    follows.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    followed_users.include?(other_user)
  end
end
