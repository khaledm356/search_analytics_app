FactoryBot.define do
  factory :user_session do
    session_token { SecureRandom.uuid }
    ip_address { Faker::Internet.public_ip_v4_address }
  end
end
