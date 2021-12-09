class Country < ApplicationRecord
  has_many :charts
  has_many :documents

  before_create :slugify

  def slugify
    self.slug = name.parameterize
  end

end
