class EmbassyGeneralAlert < ApplicationRecord
  belongs_to :country, primary_key: :country, foreign_key: :country_name, optional: true
end
