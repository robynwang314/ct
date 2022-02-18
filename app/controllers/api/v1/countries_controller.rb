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

        # if not, just search and parse
        if country_stats.nil? || country_stats.blank?
          # assuming covid Raw datum never fails
          owid_data = CovidRawDatum.find_by(
            data_source: "OWID"
          )

          country_stats = owid_data.raw_json[alpha3]
        end
        # country stats have more fields than just all_time_data
        all_cases = country_stats["all_time_data"]
        render json: all_cases
      end

      def today_stats
        country_codes(name_params)
        today_stats = OwidTodayStatsRawDatum.find_by(
          country_code: alpha3
        )

        if today_stats.nil? || today_stats.blank?
          # assuming covid Raw datum never fails
          all_latest_stats = CovidRawDatum.find_by(
            data_source: "latest OWID"
          )

          today_stats = all_latest_stats.raw_json[alpha3]
        end

        # today_stats has more fields than just raw_json
        latest_cases = today_stats["raw_json"]

        render json: latest_cases
      end

      def travel_advisory
        country_codes(name_params)
        travel_advisory_data = GetRawDataCommands::AddTravelAdvisoryCommand.new(country: name_params, alpha2: alpha2 ).execute 

        render json: travel_advisory_data
      end

      def reopenEU
        country_codes(name_params)
        reopen_EU_data = GetRawDataCommands::AddReopeneuCommand.new(alpha3: alpha3 ).execute 

        render json: reopen_EU_data
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
