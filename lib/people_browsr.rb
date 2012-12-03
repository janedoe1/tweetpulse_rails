require 'net/http'
require 'json'

=begin
  Usage:
  api = PeopleBrowsr::PeopleBrowsrAPI.new(id, key)
  json_obj = api.at_name_cloud(
    last: 'yesterday',
    count: 30,
    source: 'twitter',
    term: 'zombies',
    limit: 300,
  )
  puts json_obj['data']
=end
module PeopleBrowsr
  class PeopleBrowsrAPI
    def initialize(id, key)
      @id, @key, @base_url = id, key, 'http://api.peoplebrowsr.com'
    end

    def at_name_cloud(params={})
      fetch "atnamecloud", params
    end

    def mentions(params={})
      fetch "mentions", params
    end

    def density(params={})
      fetch "density", params
    end

    def word_cloud(params={})
      fetch "wordcloud", params
    end

    def hashtag_cloud(params={})
      fetch "hashtagcloud", params
    end

    def mentions_retweets(params={})
      fetch "mentions-retweets", params

    end

    def friends_and_followers(params={})
      fetch "friendsandfollowers", params
    end

    def top_followers(params={})
      fetch "top-followers", params
    end

    def positive_top_followers(params={})
      fetch "Top-Positive-Followers", params
    end

    def negative_top_followers(params={})
      fetch "wordcloud", params
    end

    def popularity(params={})
      fetch "popularity", params
    end

    def sentiment(params={})
      fetch "sentiment", params
    end

    def top_us_state(params={})
      fetch "top-usarea", params
    end

    def top_countries(params={})
      fetch "topcountries", params
    end

    def top_urls(params={})
      fetch "topurls", params
    end

    def top_pictures(params={})
      fetch "toppictures", params
    end

    def top_videos(params={})
      fetch "topvideos", params
    end

    def kred_outreach(params={})
      fetch "kredoutreach", params
    end

    def kred_influence(params={})
      fetch "kredinfluence", params
    end

    private
      def fetch(page, params={})
        uri = URI("#@base_url/#{page}?app_id=#@id&app_key=#@key&#{URI.encode_www_form params}")
        json = nil
        begin
          sleep 0.5 unless json.nil?
          json = JSON.parse(''.tap do |j|
            Net::HTTP.start(uri.host, uri.port) do |http|
              http.get(uri.request_uri) { |response| j << response }
            end
          end)
        end until json['status'] == 'complete'

        json
      end
  end
end
