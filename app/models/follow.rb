class Follow < ApplicationRecord
  belongs_to :user
  belongs_to :followed, class_name: 'User'

  validates :user_id, presence: true
  validates :followed_id, presence: true
end
