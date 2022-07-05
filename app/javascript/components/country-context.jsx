import React, { createContext, useState, useMemo, useContext, useEffect } from 'react'
import PropTypes from 'prop-types'
import api from '../api/api.js'
export const CountrySelectionContext = createContext();
export function CountrySelectionProvider({ children, defaultCountry = "United States" }) {
  const [country, setCountry] = useState(/* defaultCountry*/ "");
  const [alertStatus, setAlertStatus] = useState({})
  const [allTimeOWIDstats, setAllTimeOWIDstats] = useState([])
  const [reopenEUComments, setReopenEUComments] = useState({})
  const [embassyComments, setEmbassyComments] = useState({})
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


  const context = useMemo(
    () => ({
      string_parameterize,
      country,
      setCountry,
      allTimeOWIDstats,
      setAllTimeOWIDstats,
      alertStatus,
      setAlertStatus,
      reopenEUComments,
      setReopenEUComments,
      embassyComments,
      setEmbassyComments,
      expanded,
      handleCollapse,
      toggleCollapse

    }),
    [string_parameterize, country, allTimeOWIDstats, setAllTimeOWIDstats, alertStatus, setAlertStatus, reopenEUComments, setReopenEUComments, embassyComments, setEmbassyComments, expanded, handleCollapse, toggleCollapse]
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