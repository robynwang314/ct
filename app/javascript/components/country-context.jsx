import React, { createContext, useState, useMemo, useContext, useEffect } from 'react'
import PropTypes, { func } from 'prop-types'
import api from '../api/api.js'
export const CountrySelectionContext = createContext();
export function CountrySelectionProvider({ children, defaultCountry = "United States" }) {
  const [country, setCountry] = useState(/*defaultCountry*/ "");
  const [countries, setCountries] = useState([])
  const [alertStatus, setAlertStatus] = useState({})
  const [todayStats, setTodayStats] = useState({})
  const [allTimeOWIDstats, setAllTimeOWIDstats] = useState([])
  const [reopenEUComments, setReopenEUComments] = useState({})
  const [embassyComments, setEmbassyComments] = useState({})


  // async function setSelectedCountry(e) {
  //   setCountry(e)

  // const name = string_parameterize(e.label)
  // const response = await api.countries.show(name)
  // if (response?.data) {
  //   setAllTimeOWIDstats(response.data.stats.data)
  //   setTodayStats(response.data.stats.data[response.data.stats.data.length - 1])
  //   // setAlertStatus(response.data.travel_advisory)
  //   setReopenEUComments(response.data.comments)
  //   setEmbassyComments(response.data.country_info_from_embassy)
  // }
  // }

  const string_parameterize = str1 => {
    return str1.trim().toLowerCase().replace(/[^a-zA-Z0-9 -]/, "").replace(/\s/g, "-");
  };


  // async function getOWIDstats(country) {
  //   const response = await api.countries.owid_stats(country)
  //   try {
  //     if (response) {
  //       console.log(response.data.data)
  //       setAllTimeOWIDstats(response.data.data)
  //       setTodayStats(response.data.data[response.data.data.length - 1])
  //     }
  //   } catch {
  //     console.log(response)
  //   }
  // }

  // async function getEmbassyComments(country) {
  //   const response = await api.countries.embassy_information(country)
  //   try {
  //     if (response) {
  //       console.log(response.data.data)
  //       setEmbassyComments(response.data.data)
  //     }
  //   } catch {
  //     console.log(response)
  //   }
  // }

  const context = useMemo(
    () => ({
      string_parameterize,
      country,
      setCountry,
      countries,
      setCountries,
      allTimeOWIDstats,
      todayStats,
      alertStatus,
      setAlertStatus,
      reopenEUComments,
      setReopenEUComments,
      embassyComments
    }),
    [string_parameterize, country, countries, allTimeOWIDstats, todayStats, alertStatus, setAlertStatus, reopenEUComments, setReopenEUComments, embassyComments]
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