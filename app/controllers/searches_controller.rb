class SearchesController < ApplicationController
  def create
    query = params[:query].to_s.strip
    return head :bad_request if query.blank?


    redis_last_query_key   = "last_query:#{session_token}"
    redis_cached_list_key  = "searches:#{session_token}"

    last_query = $redis.get(redis_last_query_key)
    if last_query.present? &&
       query.start_with?(last_query) &&
       @current_user_session.searches.exists?(query: last_query)

      @current_user_session.searches.find_by(query: last_query)&.update(query: query)

      $redis.set(redis_last_query_key, query, ex: 10.minutes)

      index = $redis.lrange(redis_cached_list_key, 0, -1).index(last_query)
      $redis.lset(redis_cached_list_key, index, query) if index

    else
      @current_user_session.searches.create!(query: query)

      $redis.set(redis_last_query_key, query, ex: 10.minutes)

      $redis.rpush(redis_cached_list_key, query)
      $redis.ltrim(redis_cached_list_key, 0, 99)
    end

    head :ok
  end


  def analytics
    @searches = $redis.lrange("searches:#{session_token}", 0, -1).reverse


    @top_searches = @searches.tally.sort_by { |_, count| -count }.to_h
  end

  def session_token
    @current_user_session.session_token
  end
end
