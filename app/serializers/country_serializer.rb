class CountrySerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :slug
  has_many :documents
end
