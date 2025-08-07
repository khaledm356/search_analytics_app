class Search < ApplicationRecord
  belongs_to :user_session

  validates :query, presence: true
end
