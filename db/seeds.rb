# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Country.create([
  {
    name: "United States"
  }, 
  {
    name: "Spain"
  }, 
  {
    name: "Portugal"
  },
  {
    name: "Switzerland"
  }
])

Document.create([
  {
    document_type: "vaccine",
    required: true, 
    country_id: 1
  }, 
  {
    document_type: "test",
    required: true,
    pcr: true,
    validity: "24 hours",
    country_id: 1
  }, 
  {
    document_type: "vaccine",
    required: true,
    country_id: 2
  }, 
  {
    document_type: "vaccine",
    required: true,
    country_id: 3
  }, 
  {
    document_type: "test",
    required: true,
    antigen: true,
    pcr: true,
    validity: "24 hours",
    country_id: 3
  }
])