import React, { createContext, useState, useMemo, useContext, useEffect } from 'react'
import PropTypes from 'prop-types'
import api from '../api/api.js'

export const CountrySelectionContext = createContext();


async function getCountry(name) {
  useEffect(async () => {
    const response = await api.countries.show(name)
    try {
      if (response) {
        console.log(response)
      }
    } catch {
      console.log(response)
    }
  }, [])
}



export function CountrySelectionProvider({ children, defaultCountry = "United States" }) {
  const [country, setCountry] = useState(defaultCountry);
  const [countries, setCountries] = useState([])

  async function setSelectedCountry(e) {
    setCountry(e)
    const name = string_parameterize(e.label)
    // getCountry(name)
    const response = await api.countries.show(name)

    if (response) {
      console.log(response)
    }
  }

  function string_parameterize(str1) {
    return str1.trim().toLowerCase().replace(/[^a-zA-Z0-9 -]/, "").replace(/\s/g, "-");
  };

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