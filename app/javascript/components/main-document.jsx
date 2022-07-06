import React from 'react'
import { useQuery } from "react-query";
import api from '../api/api.js'
import SearchBar from './SearchBar/search-bar.jsx'
import ChartContainer from './Chart/chart-container.jsx'
import NavBarTabs from "./Nav/nav-bar-tabs.jsx"
import { useCountryContext } from './country-context.jsx'
import "./app.scss"

export const getAllCountries = () => {
  return useQuery("GET_COUNTRIES", async () =>
    await api.countries.index().then(res => {
      const { data } = res;
      return data && data.length > 0 ? data : [];
    })
  )
}

const getCountryInfo = (country, setCountryInfo) => {
  return useQuery(['SHOW_ALL', { country }], async () => {
    if (country.length != 0) {
      await api.countries.show(country.label).then(res => {
        const { data } = res;
        setCountryInfo(data)
      }).catch((e) => [
        console.log(e)
      ])
    }
  })
}

const MainDocument = () => {
  const { country, expanded, handleCollapse, setCountryInfo, countryInfo } = useCountryContext()
  const { data: allCountries } = getAllCountries()
  const { isError } = getCountryInfo(country, setCountryInfo)

  // const countryCode = country?.value
  let countryNamesList = []

  if (allCountries?.length > 0) {
    countryNamesList = allCountries?.map((country) => {
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
      {/* error in getting country? */}
      <h2 style={{ marginBottom: '0px', fontWeight: "bold" }}>{country?.label ? country.label : "No country selected"}</h2>
      <h5 style={{ marginBottom: '0', color: "red" }}>Alert Status:</h5> <p style={{ marginTop: '.35%' }}>{!isError && countryInfo?.travel_advisory}</p>
      <ChartContainer />
      <br />
      <NavBarTabs country={country} />
      {country && <button style={{ position: "fixed", zIndex: "1", top: "95%", left: "90%" }} onClick={handleCollapse}>{expanded
        ? "collapse all" : "expand all"}</button>}
      {/* <div style={{ color: "rgb(81, 82, 81)" }} dangerouslySetInnerHTML={{ __html: data?.important_info }} /> */}
    </>
  )
}


export default MainDocument;
