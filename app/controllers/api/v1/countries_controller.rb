module Api
  module V1
    class CountriesController < ApplicationController
      include HTTParty
      require 'json'

      attr_accessor :name, :country, :alpha3, :parse_page, :parse_country, :paragraphsection_exists

      def index
        # this is needed to load the countries into the select dropdown list
        countries = ISO3166::Country.find_all_countries_by_region('Europe') 
        render json: countries.as_json
      end

      def embassy_information
        name = name_params
        country_info = GetRawDataCommands::AddEmbassyInformationCommand.new(name: name).execute 

        render json: country_info
      end

      def owid_stats
        country_code = get_country_code.alpha3

        # grab from database if it exists
        country_stats = OwidCountryAllTimeDatum.find_by(
          country_code: country_code
        )

        # country stats have more fields than just all_time_data
        all_cases = country_stats["all_time_data"]
        render json: all_cases
      end

      def today_stats        
        country_code = get_country_code.alpha3

        today_stats = OwidTodayStat.find_by(
          country_code: country_code
        )

        latest_cases = today_stats["todays_stats"]
        render json: latest_cases
      end

      def travel_advisory
        country_code = get_country_code.alpha2
        country_advisory = TravelAdvisory.find_by(country_code: country_code)

        message = country_advisory["advisory"]
        render json: message
      end

      def reopenEU
        country_code = get_country_code.alpha3
        reopen_EU_data = ReopenEuByCountry.find_by(country_code: country_code)
      
        country_reopen_EU = reopen_EU_data["raw_json"]
        render json: country_reopen_EU
      end

      def show
        country = get_country_code

        render json: country
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
