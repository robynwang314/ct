module Api
  module V1
    class CountriesController < ApplicationController
      include HTTParty
      include CssParser
      require 'json'

      attr_accessor :name, :country, :alpha3, :parse_page, :parse_country, :paragraphsection_exists

      def index
        # this is needed to load the countries into the select dropdown list
        countries = ISO3166::Country.find_all_countries_by_region('Europe') 
        render json: countries.as_json
      end

      def show
        GetRawDataCommands::AddEmbassyInformationCommand.new(name:  name_params).execute
       
        all_content = GetRawDataCommands::AddEmbassyTravelInfoCommand.new(name:  name_params).execute

        country = get_country_code


        # respond_to do |format|
        #   format.json {
        #     render json: country
        #   }
        #   format.html {
        #     render json: country 
           
        #   }
        # end


        # render json: country
       
        render json: all_content
      end

      private

      def name_params
        params.require(:name)
      end

      def get_country_code
        Country.find(name_params.titleize)
      end

    end
  end
end
