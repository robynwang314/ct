module Api
  module V1
    class CountriesController < ApplicationController

      include HTTParty
      require 'json'

      def index
        countries = ISO3166::Country.find_all_countries_by_region('Europe')
        render json: countries.as_json

        # countries = Country.all
        # render json: CountrySerializer.new(countries, options).serialized_json

      end

      def show
        name = params[:name]
        c = ISO3166::Country.find_country_by_name(name.titleize)
        alpha3 = c.alpha3

        countries = HTTParty.get('https://covid.ourworldindata.org/data/owid-covid-data.json')
        render json: countries[alpha3]
     
        # country = Country.find_by(slug: params[:slug])
        # render json: CountrySerializer.new(country, options).serialized_json
      end

      private

      def options
        @options ||= { include: %i[documents] }
      end

    end
  end
end
