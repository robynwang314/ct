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

        all_countries_data = Country.get_all_our_world_in_data
        @country_stats = all_countries_data[alpha3]

        @travel_advisory = Country.get_travel_advisory(alpha2)
       
        json_visa = JSON.parse(Country.get_all_reopenEU_data) 
        all_country_info = json_visa.select { |country| country["nutscode"] == alpha3 }
        get_domain = all_country_info[0]["indicators"].select {|data| data["comment"] != ""}     
    
        all_comments_list = []
        get_domain.each_with_object({}) do |c| 
          comment = { }
          comment["domain_id"] =  c["domain_id"]
          comment["domain_name"] = c["domain_name"]
          comment["indicator_id"] = c["indicator_id"]
          comment["indicator_name"] = c["indicator_name"]
          comment["comment"] = c["comment"]
          comment["value"] = c["value"]

          all_comments_list << comment
        end
        
        @sorted_comments_list = all_comments_list.group_by { |d| d["domain_name"] }
        # puts JSON.pretty_generate(@sorted_comments_list) 

        response = {:stats => @country_stats, :travel_advisory => @travel_advisory, :comments => @sorted_comments_list}
        render json: response

        # country = Country.find_by(slug: params[:slug])
        # render json: CountrySerializer.new(country, options).serialized_json
      end

    end
  end
end
