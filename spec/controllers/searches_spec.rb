require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
  let(:session_token) { SecureRandom.uuid }
  let!(:user_session) { UserSession.create!(session_token: session_token, ip_address: "127.0.0.1") }

  before do
    session[:user_session_token] = session_token
    $redis.flushdb
  end

  def redis_list
    $redis.lrange("searches:#{session_token}", 0, -1)
  end

  def redis_last_query
    $redis.get("last_query:#{session_token}")
  end

  describe "POST #create" do
    it "creates the first valid search" do
      post :create, params: { query: "how to cook rice" }

      expect(response).to have_http_status(:ok)
      expect(Search.count).to eq(1)
      expect(Search.last.query).to eq("how to cook rice")

      expect(redis_list).to include("how to cook rice")
      expect(redis_last_query).to eq("how to cook rice")
    end

    it "updates last query if user is still typing (pyramid problem)" do
      post :create, params: { query: "how to cook" }
      sleep 1
      post :create, params: { query: "how to cook rice" }

      expect(Search.count).to eq(1)
      expect(Search.last.query).to eq("how to cook rice")

      expect(redis_list).to include("how to cook rice")
      expect(redis_list).not_to include("how to cook")
    end

    it "creates a new search if query is unrelated to previous" do
      post :create, params: { query: "what is ai" }
      sleep 1
      post :create, params: { query: "top laptops 2025" }

      expect(Search.count).to eq(2)
      expect(Search.last.query).to eq("top laptops 2025")

      expect(redis_list).to include("what is ai", "top laptops 2025")
    end

    it "ignores blank queries" do
      post :create, params: { query: " " }

      expect(response).to have_http_status(:bad_request)
      expect(Search.count).to eq(0)
      expect(redis_list).to be_empty
      expect(redis_last_query).to be_nil
    end

    it "does not update old query if older than 5 seconds" do
      post :create, params: { query: "best cities" }
      post :create, params: { query: "best cities to live in" }

      expect(Search.count).to eq(1)
      expect(Search.last.query).to eq("best cities to live in")

      expect(redis_list).to include("best cities to live in")
    end

    it "does update if new query doesn't start with previous" do
      post :create, params: { query: "apple macbook" }
      post :create, params: { query: "best phones" }

      expect(Search.count).to eq(2)
      expect(redis_list).to include("apple macbook", "best phones")
    end
  end
end
