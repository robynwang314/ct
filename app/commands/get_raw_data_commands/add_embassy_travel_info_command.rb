module GetRawDataCommands
  class AddEmbassyTravelInfoCommand
    include HTTParty
    include CssParser
    require 'json'

    attr_accessor :name, :country, :parse_page, :parse_country, :paragraphsection_exists

    def initialize(name:)
      @name = name
    end

    def execute
 
      # https://travel.state.gov/etc/designs/tsg-rwd/clientlib.css
      return match_content_with_css

    end

    private

    #  def match_content_with_css
    #   get_list_of_embassy_links

    #   all_general_content = all_content

    #   # advisory only
    #   main_content = parse_country.at_css(".tsg-rwd-csi-travel-advisories")

    #   # embassy messages
    #   # .tsg-rwd-csi-travel-rss

    #   # quick facts
    #   # .tsg-rwd-sidebar-qf-csi-show

    

    #   css = CssParser::Parser.new

    #   css.load_uri!('https://travel.state.gov/apps/tsg-rwd/components/content/advisorybanner/clientlib.css')

    #   css.load_uri!('https://travel.state.gov/apps/tsg-rwd/components/content/EmergencyAlert/clientlib.css')


    #   css.each_selector do |selector, declarations, specificity|
    #     next unless selector =~ /^[\d\w\s\#\.\-]*$/ # Some of the selectors given by css_parser aren't actually selectors.
    #     begin
    #       elements = main_content.css(selector)
    #       elements.each do |match|
    #         match["style"] = [match["style"], declarations].compact.join(" ")
    #       end
    #     rescue
    #       logger.info("Couldn't parse selector '#{selector}'")
    #     end
    #   end

    #   html_with_inline_styles = main_content.to_s 

    #   # return main_content.to_html

    #   return html_with_inline_styles
    # end
    
    def match_content_with_css
      get_list_of_embassy_links
      main_content = all_content
      all_stylesheets

      base_url = "https://travel.state.gov"

      css = CssParser::Parser.new
      all_stylesheets_href = all_stylesheets.map { |stylesheet| next if  stylesheet["href"].include?(".ico"); base_url + stylesheet["href"]  }.compact

      all_stylesheets_href.each do |stylesheet| 
        css.load_uri!(stylesheet)
      end

      css.each_selector do |selector, declarations, specificity|
        next unless selector =~ /^[\d\w\s\#\.\-]*$/ # Some of the selectors given by css_parser aren't actually selectors.
        begin
          elements = main_content.css(selector)
          elements.each do |match|
            match["style"] = [match["style"], declarations].compact.join(" ")
          end
        rescue
          logger.info("Couldn't parse selector '#{selector}'")
        end
      end

      html_with_inline_styles = main_content.to_s 


      return html_with_inline_styles

    end



    def all_stylesheets
      stylesheets = parse_country.css('link').attribute(rel: "stylesheet")

      return stylesheets
    end

    def all_content
      # full main content 
      main_content = parse_country.at_css(".tsg-rwd-main-CSI-page-items-tsg_rwd_main_content")

      return main_content
    end


    def get_list_of_embassy_links
      titleized_name = name.titleize
      # get list of all countries from embassy's travel advisory site
      country_info = HTTParty.get("https://travel.state.gov/content/travel/en/international-travel/International-Travel-Country-Information-Pages/#{titleized_name}.html")

      @parse_country ||= Nokogiri::HTML(country_info)
    end

  end

end
