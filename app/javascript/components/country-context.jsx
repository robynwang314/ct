import React, { createContext, useState, useContext } from 'react'
import PropTypes from 'prop-types'
import api from '../api/api.js'
export const CountrySelectionContext = createContext();
export function CountrySelectionProvider({ children, defaultCountry = "United States" }) {
  const [country, setCountry] = useState(/* defaultCountry*/ "");
  const [countryInfo, setCountryInfo] = useState({})
  const [reopenEUComments, setReopenEUComments] = useState({})
  const [toggleCollapse, setToggleCollapse] = useState(false)
  const [expanded, setExpanded] = useState(true)

  // need to fix this for countries with multiple words
  const string_parameterize = str1 => {
    return str1?.trim().toLowerCase().replace(/[^a-zA-Z0-9 -]/, "").replace(/\s/g, "-");
  };

  const handleCollapse = () => {
    setToggleCollapse(true)
    setExpanded(!expanded)

    setTimeout(() => {
      setToggleCollapse(false)
    }, 2000)
  }

  const context = {
    string_parameterize,
    country,
    setCountry,
    countryInfo,
    setCountryInfo,
    reopenEUComments,
    setReopenEUComments,
    expanded,
    handleCollapse,
    toggleCollapse
  }

  return <CountrySelectionContext.Provider value={context}>
    {children}
  </CountrySelectionContext.Provider>
}

CountrySelectionProvider.propTypes = {
  children: PropTypes.any,
  defaultCountry: PropTypes.string
}

export function useCountryContext() {
  return useContext(CountrySelectionContext)
}