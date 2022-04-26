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

        
        country_code = Country.find(name_params.titleize).alpha3
        # country_codes(name_params)
        today_stats = OwidTodayStat.find_by(
          country_code: country_code
        )

        latest_cases = today_stats["todays_stats"]
        render json: latest_cases
      end

      def travel_advisory
        country_codes(name_params)
        country_advisory = TravelAdvisory.find_by(country_code: alpha2)

        message = country_advisory["advisory"]
        render json: message
      end

      def reopenEU
        country_codes(name_params)
        reopen_EU_data = ReopenEuByCountry.find_by(country_code: alpha3)
      
        country_reopen_EU = reopen_EU_data["raw_json"]
        render json: country_reopen_EU
      end

      def show
        country_codes("United States")
      
        # country advisory
        country_advisory =  TravelAdvisory.find_by(country_code: alpha2)
        message = country_advisory["advisory"]

        # all time stats
        country_stats = OwidCountryAllTimeDatum.find_by(
          country_code: alpha3
          )
        all_cases = country_stats["all_time_data"]
          
        # todays stats
        today_stats = OwidTodayStat.find_by(
          country_code: alpha3
        )
        latest_cases = today_stats["todays_stats"]

        # TODO: embassy info
    
        # puts JSON.pretty_generate(@sorted_comments_list) 

        # create new object containing all of above info
        response = { :travel_advisory => message, :stats => all_cases, :latest_cases => latest_cases}

        # return as json
        render json: response

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
