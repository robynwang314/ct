module Api
  module V1
    class CountriesController < ApplicationController

      include HTTParty
      require 'json'

      def index
        countries = ISO3166::Country.find_all_countries_by_region('Europe')
        render json: countries.as_json
      
        # countries = HTTParty.get('https://covid.ourworldindata.org/data/owid-covid-data.json')
        # render json: countries["USA"]

        # countries = Country.all
        # render json: CountrySerializer.new(countries, options).serialized_json

      end

      def show
        country = Country.find_by(slug: params[:slug])
        render json: CountrySerializer.new(country, options).serialized_json
      end

      private

      def options
        @options ||= { include: %i[documents] }
      end

      def nested_hash_value(obj,key)
        if obj.respond_to?(:key?) && obj.key?(key)
          obj[key]
        elsif obj.respond_to?(:each)
          r = nil
          obj.find{ |*a| r=nested_hash_value(a.last,key) }
          r
        end
      end


      def search_hash(h, search)
        return h[search] if h.fetch(search, false)

        h.keys.each do |k|
          answer = search_hash(h[k], search) if h[k].is_a? Hash
          return answer if answer
        end

        false
      end

    end
  end
end
