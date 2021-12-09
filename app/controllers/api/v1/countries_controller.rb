module Api
  module V1
    class CountriesController < ApplicationController

      def index
        countries = Country.all
        render json: CountrySerializer.new(countries, options).serialized_json
      end

      def show
        country = Country.find_by(slug: params[:slug])
        render json: CountrySerializer.new(country, options).serialized_json
      end

      private

     def options
        @options ||= { include: %i[documents] }
      end
    end
  end
end
