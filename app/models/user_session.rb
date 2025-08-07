class UserSession < ApplicationRecord
  has_many :searches, dependent: :destroy
end
