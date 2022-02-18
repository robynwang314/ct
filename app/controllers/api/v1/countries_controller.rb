module Api
  module V1
    class CountriesController < ApplicationController
      include HTTParty
      require 'json'

      attr_accessor :name, :country, :alpha2, :alpha3, :parse_page, :parse_country, :paragraphsection_exists

      def index
        countries = ISO3166::Country.find_all_countries_by_region('Europe')
        render json: countries.as_json

        # countries = Country.all
        # render json: CountrySerializer.new(countries, options).serialized_json
      end

      def country_codes(name)
        # using the name, find the necessary country codes
        @c = ISO3166::Country.find_country_by_name(name.titleize)
        @alpha2 = @c.alpha2
        @alpha3 = @c.alpha3
      end

      def embassy_information
        name = name_params
        country_info = GetRawDataCommands::AddEmbassyInformationCommand.new(name: name).execute 

        render json: country_info
      end

      def owid_stats
        country_codes(name_params)

        # grab from database if it exists
        country_stats = OwidCountryAllTimeDatum.find_by(
          country_code: alpha3
        )

        # country stats have more fields than just all_time_data
        all_cases = country_stats["all_time_data"]
        render json: all_cases
      end

      def today_stats
        country_codes(name_params)
        today_stats = OwidTodayStatsRawDatum.find_by(
          country_code: alpha3
        )

        latest_cases = today_stats["raw_json"]
        render json: latest_cases
      end

      def travel_advisory
        country_codes(name_params)
        country_advisory = TravelAdvisoryRawDatum.find_by(country_code: alpha2)

        message = country_advisory["raw_json"]["advisory"]
        render json: message
      end

      def reopenEU
        country_codes(name_params)
        reopen_EU_data = ReopenEuByCountry.find_by(country_code: alpha3)
      
        country_reopen_EU = reopen_EU_data["raw_json"]
        render json: country_reopen_EU
      end

      def show
        # get the selected country name
    
        # puts JSON.pretty_generate(@sorted_comments_list) 

        # create new object containing all of above info
        # response = {:stats => @country_stats, :travel_advisory => @travel_advisory, :country_info_from_embassy => @country_info_from_embassy, :comments => @sorted_comments_list }

        # return as json
        # render json: response

        # country = Country.find_by(slug: params[:slug])
        # render json: CountrySerializer.new(country, options).serialized_json
      end

      private

      def name_params
        params.require(:name)
      end

    end
  end
end
