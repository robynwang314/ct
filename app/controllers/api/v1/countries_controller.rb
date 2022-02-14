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

        @country_info_from_embassy = country_info
      end

      def owid_stats
        # will need to do below command with sidekiq
        # and move to a nightly job
        # OwidJob.perform_at(Time.now)

        country_codes(name_params)

        owid_data = CovidRawDatum.where(
          data_source: "OWID"
        )[0]

        if !owid_data.blank?
          @country_stats = CovidRawDatum.where(
            data_source: "OWID"
          )[0].raw_json[alpha3]
        else
          # get country statistics from OWID
          all_countries_data = Country.get_all_our_world_in_data
          @country_stats = all_countries_data[alpha3]
        end 
        # render json: @country_stats
      end

      def travel_advisory
        country_codes(name_params)

        travel_advisory_data = AddRawDataCommands::AddTravelAdvisoryCommand.new(country: name_params, alpha2: alpha2 ).execute 
        @travel_advisory = travel_advisory_data
      end

      def reopenEU
        country_codes(name_params)
        reopen_EU_data = AddRawDataCommands::AddReopeneuCommand.new(alpha3: alpha3 ).execute 

        @sorted_comments_list = reopen_EU_data
      end

      def show
        # get the selected country name
        @name = name_params

        country_codes(name)
        embassy_information
        owid_stats
        travel_advisory
        reopenEU
     
        # puts JSON.pretty_generate(@sorted_comments_list) 

        # create new object containing all of above info
        response = {:stats => @country_stats, :travel_advisory => @travel_advisory, :country_info_from_embassy => @country_info_from_embassy, :comments => @sorted_comments_list }

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
