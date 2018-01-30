class TweetsController < ApplicationController
  include ActionController::Caching::Pages
  self.page_cache_directory = :domain_cache_directory
  caches_page :year, :data

  def year
    @clinton_tweets = Tweet.tweets_that_include(['hillary', 'clinton', 'crooked'])
    @obama_tweets = Tweet.tweets_that_include(['barack', 'obama'], ['obamacare'])
    @trump_tweets = Tweet.tweets_that_include(['donald', 'trump', ' i ', ' me '], ['ivanka',' son', 'ballard'])
  end

  def data
    @results = File.read("all-tweets.json")
    respond_to do |format|
      format.json {render json: @results}
    end
  end

  def circle
    tweets = Tweet.all
    @results = [{year: '0'}]
    weeks = Array( Date.parse("2017-01-20")..Date.parse("2018-01-20") ).select(&:sunday?).map(&:to_s)
    weeks.each.with_index(1) do |d, i|
      tweet_count = Tweet.where(:date => Date.parse(d).beginning_of_week..Date.parse(d).end_of_day).size
      @results[0]["Week #{i}"] = tweet_count
    end
    respond_to do |format|
      format.json {render json: @results}
    end
  end


  private
    def domain_cache_directory
      Rails.root.join("public", request.domain)
    end

end
