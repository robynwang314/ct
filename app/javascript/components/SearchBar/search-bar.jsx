import React from "react"
import PropTypes from 'prop-types'
import Select from 'react-select'
import "./search-bar.scss"

import { useCountryContext } from '../country-context.jsx'

const options = [
  { value: 'chocolate', label: 'Chocolate' },
  { value: 'strawberry', label: 'Strawberry' },
  { value: 'vanilla', label: 'Vanilla' }
]

const SearchBar = ({ countries }) => {
  const { country, setSelectedCountry } = useCountryContext();

  let countryNamesList = []

  if (countries.length >= 0) {
    countryNamesList = countries.map((c, index) => {
      return { value: c.attributes.slug, label: c.attributes.name }
    })
    countryNamesList
  }


  return (
    <div style={{ width: '97%', margin: '.5%' }}>
      <Select
        className="selectable"
        placeholder="Select a country"
        options={countryNamesList}
        isClearable={true}
        onChange={setSelectedCountry}
      />
    </div>
  )
}

SearchBar.propTypes = {

}

export default SearchBar