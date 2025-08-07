FactoryBot.define do
  factory :search do
    query { "Example search query" }
    association :user_session
  end
end
