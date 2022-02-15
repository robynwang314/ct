import React, { createContext, useState, useMemo, useContext, useEffect } from 'react'
import PropTypes, { func } from 'prop-types'
import api from '../api/api.js'
export const CountrySelectionContext = createContext();
export function CountrySelectionProvider({ children, defaultCountry = "United States" }) {
  const [country, setCountry] = useState(/*defaultCountry*/ "");
  const [countries, setCountries] = useState([])
  const [alertStatus, setAlertStatus] = useState({})
  const [allTimeOWIDstats, setAllTimeOWIDstats] = useState([])
  const [reopenEUComments, setReopenEUComments] = useState({})
  const [embassyComments, setEmbassyComments] = useState({})

  const string_parameterize = str1 => {
    return str1.trim().toLowerCase().replace(/[^a-zA-Z0-9 -]/, "").replace(/\s/g, "-");
  };

  const context = useMemo(
    () => ({
      string_parameterize,
      country,
      setCountry,
      countries,
      setCountries,
      allTimeOWIDstats,
      setAllTimeOWIDstats,
      alertStatus,
      setAlertStatus,
      reopenEUComments,
      setReopenEUComments,
      embassyComments,
      setEmbassyComments
    }),
    [string_parameterize, country, countries, allTimeOWIDstats, setAllTimeOWIDstats, alertStatus, setAlertStatus, reopenEUComments, setReopenEUComments, embassyComments, setEmbassyComments]
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