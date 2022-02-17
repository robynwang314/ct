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
        country_info = AddRawDataCommands::AddEmbassyInformationCommand.new(name: name).execute 

        render json: country_info
      end

      def owid_stats
        country_codes(name_params)

        owid_data = CovidRawDatum.find_by(
          data_source: "OWID"
        )
       
        if owid_data.nil? || owid_data.blank?
          AddRawDataCommands::AddOwidCommand.new().execute
        end
        
        country_stats = owid_data.raw_json[alpha3]
        render json: country_stats
      end

      def today_stats
        country_codes(name_params)
        today_stats = AddRawDataCommands::AddTodayStatsCommand.new(name: name_params, alpha3: alpha3).execute

        render json: today_stats
      end

      def travel_advisory
        country_codes(name_params)
        travel_advisory_data = AddRawDataCommands::AddTravelAdvisoryCommand.new(country: name_params, alpha2: alpha2 ).execute 

        render json: travel_advisory_data
      end

      def reopenEU
        country_codes(name_params)
        reopen_EU_data = AddRawDataCommands::AddReopeneuCommand.new(alpha3: alpha3 ).execute 

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
