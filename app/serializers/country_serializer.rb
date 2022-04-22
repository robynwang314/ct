class CountrySerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :slug, :alpha2, :alpha3
  has_many :documents
end
