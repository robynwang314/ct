require 'rails_helper'

RSpec.describe "CountriesControllers", type: :request do
  describe "returns a success response" do
    it "#index" do
      get '/api/v1/countries'
      expect(response).to have_http_status(:success)
    end

    # let!(:country_name) {"Austria"}
    # it "#embassy_information" do
    #   get '/api/v1/countries/embassy_information', params: {name: country_name}
      
    #   pp response 
    # end
  
  end


end
