require 'net/http'
require 'json'

=begin
  Usage:
  api = Kred::KredAPI.new(id, key)
  json_obj = api.kred_score(
    source: 'twitter',
    term: 'zombies',
  )
  puts json_obj['data']
=end
module Kred
  class KredAPI
    def initialize(id, key)
      @id, @key, @base_url = id, key, 'http://api.kred.com'
    end

    def kred(params={})
      fetch "kred", params
    end

    def kred_score(params={})
      fetch "kredscore", params
    end
    
    def kred_retweet_influence(params={})
      fetch "kredretweetinfluence", params
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
