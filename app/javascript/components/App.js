import React, { useEffect, useState } from 'react'
import PropTypes from 'prop-types'
import axios from 'axios'
import { hot } from 'react-hot-loader/root';
import { useCountryContext, CountrySelectionProvider } from './country-context.jsx'
import api from '../api/api.js'
import SearchBar from './SearchBar/search-bar.jsx'
import ChartContainer from './Chart/chart-container.jsx'
import Documents from "./Documents/documents.jsx"
import "./app.scss"


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


export const MainDocument = () => {
  const { country, countries, setCountries, alertStatus } = useCountryContext()
  const countryCode = country?.value
  // console.log(alertStatus[countryCode]?.advisory)
  let countryNamesList = []

  getCountries(setCountries)

  if (countries.length > 0) {
    countryNamesList = countries.map((country) => {
      return country.data.name
    })
    countryNamesList[17] = "United Kingdom"
    countryNamesList[33] = "Moldova, Republic of"
    countryNamesList.unshift("United States")
    countryNamesList
  }

  return (
    <>
      <SearchBar countryNamesList={countryNamesList} />
      {/* <h1 style={{ marginBottom: '0px' }}>{country ? country?.label ? country.label : country : "Select a Country"}</h1> */}
      <h3 style={{ marginBottom: '0' }}> Alert Status:</h3> <p>{alertStatus[countryCode]?.advisory?.message}</p>
      <ChartContainer />
      <Documents />
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

