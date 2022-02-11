import React, { useEffect, useState } from 'react'
import PropTypes from 'prop-types'
import { hot } from 'react-hot-loader/root';
import { Nav, NavDropdown, Tab, Row } from 'react-bootstrap'
import { useCountryContext, CountrySelectionProvider } from './country-context.jsx'
import api from '../api/api.js'
import SearchBar from './SearchBar/search-bar.jsx'
import ChartContainer from './Chart/chart-container.jsx'
import NavBarTabs from "./Nav/nav-bar-tabs.jsx"
import "./app.scss"

import NavigationButtons from "./Nav/navigation-buttons.jsx"

async function getCountries(setCountries) {
  useEffect(async () => {
    const response = await api.countries.index()
    try {
      if (response) {
        setCountries(response.data)
      }
    } catch {
      console.log(response)
    }
  }, [])
}

// sample function
async function getAlert() {
  useEffect(async () => {
    const response = await api.countries.travel_advisory("spain")
    try {
      if (response) {
        console.log(response.data.data)
      }
    } catch {
      console.log(response)
    }
  }, [])
}


export const MainDocument = () => {
  const { country, countries, setCountries, alertStatus, data } = useCountryContext()
  const countryCode = country?.value
  // console.log(alertStatus[countryCode]?.advisory)
  let countryNamesList = []

  getCountries(setCountries)

  getAlert()

  if (countries.length > 0) {
    countryNamesList = countries.map((country) => {
      return country.data.name
    })
    countryNamesList[17] = "United Kingdom"
    countryNamesList[33] = "Moldova, Republic of"
    countryNamesList.unshift("United States")
    countryNamesList.sort()
  }

  return (
    <>
      <SearchBar countryNamesList={countryNamesList} />
      <br />
      <h2 style={{ marginBottom: '0px', fontWeight: "bold" }}>{country?.label ? country.label : "No Country selected"}</h2>
      <h5 style={{ marginBottom: '0', color: "red" }}> Alert Status:</h5> <p style={{ marginTop: '.35%' }}>{alertStatus[countryCode]?.advisory?.message}</p>
      <ChartContainer />
      <br />
      <NavBarTabs country={country} />

      <div style={{ color: "rgb(81, 82, 81)" }} dangerouslySetInnerHTML={{ __html: data?.important_info }} />
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

