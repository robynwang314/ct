module Api
  module V1
    class CountriesController < ApplicationController
      include HTTParty
      require 'json'

      attr_accessor :parse_page, :parse_country, :name

      # def initialize
        # doc = HTTParty.get("https://de.usembassy.gov/covid-19-information/")
        # @parse_page ||= NOKOgiri::HTML(doc)
      # end

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

       doc = HTTParty.get("https://travel.state.gov/content/travel/en/traveladvisories/COVID-19-Country-Specific-Information.html")
        @parse_page ||= Nokogiri::HTML(doc)

        specific_country = HTTParty.get(get_country_embassy_link(name.titleize))
        @parse_country ||= Nokogiri::HTML(specific_country)

        @build_country_info = build_country_info

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

        response = {:stats => @country_stats, :travel_advisory => @travel_advisory, :comments => @sorted_comments_list, :build_country_info => @build_country_info}
        render json: response

        # country = Country.find_by(slug: params[:slug])
        # render json: CountrySerializer.new(country, options).serialized_json
      end

      private

      def get_country_embassy_link(name)
        str_name = name.to_s
        parse_page.css("a:contains('#{str_name}')").first['href']
      end


      def build_country_info
        main = parse_country.at_css(".main") 
        main_content_wrapper = parse_country.at_css(".main-content-wrapper")
      
        if main
          all_content = main
        elsif main_content_wrapper
          all_content = main_content_wrapper
        end

        all_embassy_info = {}
        important_info = []
        country_specific = []
        testing_vaccine = []
        entry_exit = []
        movement_restrictions = [] 
        quarantine = []

        all_content.children.each_with_object({}) do |c|
          important_info << c.to_html
          next if c.text.titleize.include? ("Country-Specific Information").titleize
          
          country_specific << c.to_html
          next if c.text.titleize.include? ("COVID-19 TESTING").titleize

          testing_vaccine << c.to_html
          next if c.text.titleize.include? ("Entry and Exit Requirements").titleize

          entry_exit << c.to_html
          next if c.text.titleize.include? ("Movement Restrictions").titleize

          movement_restrictions << c.to_html
          next if c.text.titleize.include? ("Quarantine Information").titleize

          quarantine << c.to_html
          next if c.text.titleize.include? ("Fines for Non-Compliance").titleize
        end

        all_embassy_info["important_info"] = important_info
        # all_embassy_info["country_specific"] = country_specific
        # all_embassy_info["testing_vaccine"] = important_info
        # all_embassy_info["entry_exit"] = important_info
        # all_embassy_info["movement_restrictions"] = movement_restrictions
        # all_embassy_info["quarantine"] = important_info
        
        return all_embassy_info
      end

    end
  end
end
