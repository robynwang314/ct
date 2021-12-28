import React from 'react'
import PropTypes from 'prop-types'
import { useCountryContext } from '../country-context.jsx'
import "./documents.scss"


const Documents = ({ }) => {
  const { country, countryInformation } = useCountryContext()
  const all_travel_info = countryInformation?.Travel

  // const skip = [2004, 2005, 2006, 2007]

  // const remove = all_travel_info?.filter(c => !skip.includes(c.indicator_id))

  const sorted = all_travel_info?.map((travel_indicator) => {
    return (
      <>
        <div className="comments-border" />
        <h4>{travel_indicator?.indicator_name}</h4>
        <div style={{ color: "rgb(81, 82, 81)" }} dangerouslySetInnerHTML={{ __html: travel_indicator?.comment }} />
      </>
    )
  })

  return (
    <div>
      <br />
      {country?.label ? <h2 style={{ fontWeight: 'bold' }}>Travel Information</h2> : ''}
      <div className="documents-container" style={{ textAlign: "left" }}>
        {sorted}
      </div>
    </div>
  )
}

Documents.propTypes = {

}

export default Documents;