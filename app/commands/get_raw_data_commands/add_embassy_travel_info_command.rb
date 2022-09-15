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
      return all_content

    end

    private

    def all_content 
      get_list_of_embassy_links

      main_content = parse_country.at_css(".tsg-rwd-main-CSI-page-items-tsg_rwd_main_content")

      css = CssParser::Parser.new
      css.load_uri!('https://travel.state.gov/etc/designs/tsg-rwd/clientlib.css')

      # css.each_selector do |selector, declarations, specificity|
      #   main_content.css(selector).each do |element|
      #     style = element.attributes["style"]&.value || ""
      #     element.set_attribute('style', [style, declarations].compact.join(" "))
      #   end

      # end

      # main_content.to_s
    

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

      # return main_content.to_html

      return html_with_inline_styles
    end


    def get_list_of_embassy_links
      titleized_name = name.titleize
      # get list of all countries from embassy's travel advisory site
      country_info = HTTParty.get("https://travel.state.gov/content/travel/en/international-travel/International-Travel-Country-Information-Pages/#{titleized_name}.html")

      @parse_country ||= Nokogiri::HTML(country_info)
    end

  end

end
