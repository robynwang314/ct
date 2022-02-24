import React, { useState, useMemo } from "react"
import PropTypes from 'prop-types'
import Select from 'react-select'
import "./search-bar.scss"
import countryList from 'react-select-country-list'


import { useCountryContext } from '../country-context.jsx'



const SearchBar = ({ countryNamesList }) => {
  const { setCountry } = useCountryContext();
  let allCountriesKeyValuePair = []

  for (const country of countryNamesList) {
    let allCountries = countryList().getData()
    let countryKeyValuePair = allCountries.find(o => o.label === country);
    allCountriesKeyValuePair.push(countryKeyValuePair)
  }

  allCountriesKeyValuePair[8] && (allCountriesKeyValuePair[8]["label"] = "Czech Republic")

  return (
    <div style={{ width: '97%', margin: '.5%' }}>
      <Select
        className="selectable"
        placeholder="Select a country"
        options={allCountriesKeyValuePair}
        isClearable={true}
        onChange={setCountry}
      />
    </div>
  )
}

SearchBar.propTypes = {

}

export default SearchBar