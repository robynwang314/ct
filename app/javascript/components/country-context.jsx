import React, { createContext, useState, useMemo, useContext } from 'react'
import PropTypes from 'prop-types'

export const CountrySelectionContext = createContext();

export function CountrySelectionProvider({ children, defaultCountry = "United States" }) {
  const [country, setCountry] = useState(defaultCountry);
  const [countries, setCountries] = useState([])

  function setSelectedCountry(e) {
    setCountry(e?.label)
  }

  const context = useMemo(
    () => ({
      country,
      setCountry,
      setSelectedCountry,
      countries,
      setCountries,
    }),
    [country, countries, setSelectedCountry]
  );

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