import React from 'react'
import { useCountryContext } from '../country-context.jsx'

const TravelAdvisory = () => {
  const { countryInfo } = useCountryContext()

  return (
    <p style={{ margin: "2% 0", color: "red", fontWeight: "700" }} > {countryInfo?.travel_advisory}</p >
  )
}

export default TravelAdvisory;