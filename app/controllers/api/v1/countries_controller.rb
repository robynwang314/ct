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
        alpha2 = c.alpha2
        alpha3 = c.alpha3

        countries = HTTParty.get('https://covid.ourworldindata.org/data/owid-covid-data.json')
      
        @country_stats = countries[alpha3]
        @travel_advisory = HTTParty.get('https://www.travel-advisory.info/api?countrycode='+alpha2)
 
        visa = HTTParty.get('https://reopen.europa.eu/api/covid/v1/eutcdata/data/en/all/all')
        json_visa = JSON.parse(visa) 
        all_country_info = json_visa.select { |country| country["nutscode"] == "AUT" }
        get_domain = all_country_info[0]["indicators"].select {|data| data["comment"] != ""}     
    
        list = []
        get_domain.each_with_object({}) do |h| 
          obj = { }
          obj["domain_id"] =  h["domain_id"]
          obj["domain_name"] = h["domain_name"]
          obj["indicator_id"] = h["indicator_id"]
          obj["indicator_name"] = h["indicator_name"]
          obj["comment"] = h["comment"]

          list << obj
        end
        
    
        puts JSON.pretty_generate(list) 
        # puts get_domain.select {|info| info["indicator_id"] == 7002}

        response = {:stats => @country_stats, :travel_advisory => @travel_advisory}
        render json: response

        # country = Country.find_by(slug: params[:slug])
        # render json: CountrySerializer.new(country, options).serialized_json
      end

      private

      # def options
      #   @options ||= { include: %i[documents] }
      # end

    end
  end
end
