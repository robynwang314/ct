import React, { useEffect, useState } from 'react'
import PropTypes from 'prop-types'
import { hot } from 'react-hot-loader/root';
import { useCountryContext, CountrySelectionProvider } from './country-context.jsx'
import api from '../api/api.js'
import SearchBar from './SearchBar/search-bar.jsx'
import ChartContainer from './Chart/chart-container.jsx'
import NavBarTabs from "./Nav/nav-bar-tabs.jsx"
import "./app.scss"

export async function getCountries(setCountries) {
  try {
    const response = await api.countries.index()
    if (response) {
      setCountries(response.data)
    }
  } catch (error) {
    console.log(error)
  }
}

export async function getAlertStatus(country, setLoading, setAlertStatus) {
  if (!country) return null;

  try {
    setLoading(true)
    const alert = await api.countries.travel_advisory(country.label)
    if (alert && alert.data) {
      setAlertStatus(alert.data)
    }
  } catch (error) {
    console.log(error)
  }
  finally {
    setLoading(false)
  }
}

export const MainDocument = () => {
  const { string_parameterize, country, countries, setCountries, alertStatus, setAlertStatus, expanded, handleCollapse } = useCountryContext()
  const [loading, setLoading] = useState(false)

  const countryCode = country?.value
  let countryNamesList = []

  useEffect(() => {
    getCountries(setCountries)
    getAlertStatus(country, setLoading, setAlertStatus)
  }, [country])


  if (countries.length > 0) {
    countryNamesList = countries.map((country) => {
      return country.data.iso_short_name
    })

    // separating this out for testing purposes
    if (countryNamesList[17] && countryNamesList[33]) {
      countryNamesList[17] = "United Kingdom"
      countryNamesList[33] = "Moldova, Republic of"
    }

    countryNamesList.unshift("United States")
    countryNamesList.sort()
  }

  return /*!loading && */(
    <>
      <SearchBar countryNamesList={countryNamesList} />
      <br />
      <h2 style={{ marginBottom: '0px', fontWeight: "bold" }}>{country?.label ? country.label : "No country selected"}</h2>
      <h5 style={{ marginBottom: '0', color: "red" }}>Alert Status:</h5> <p style={{ marginTop: '.35%' }}>{alertStatus?.message}</p>
      <ChartContainer />
      <br />
      <NavBarTabs country={country} />
      {country && <button style={{ position: "fixed", zIndex: "1", top: "95%", left: "90%" }} onClick={handleCollapse}>{expanded
        ? "collapse all" : "expand all"}</button>}
      {/* <div style={{ color: "rgb(81, 82, 81)" }} dangerouslySetInnerHTML={{ __html: data?.important_info }} /> */}
    </>
  )
}

const App = () => {
  return (
    <div className="app-container">
      <CountrySelectionProvider>
        <MainDocument />
      </CountrySelectionProvider>
    </div>
  )
}

App.propTypes = {

}

export default hot(App)

