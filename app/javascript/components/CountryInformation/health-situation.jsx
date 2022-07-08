import React from 'react'
import PropTypes from 'prop-types'
import { useCountryContext } from '../country-context.jsx'
import { ListGroup, Badge } from 'react-bootstrap'
import "./documents.scss"

const HealthSituation = ({ }) => {
  const { countryInfo } = useCountryContext()
  const reopenEUComments = countryInfo?.reopen_eu
  const allHealthInfo = reopenEUComments && reopenEUComments["Health Situation"]

  const parseHealthSituationInformation = allHealthInfo?.filter((data) => data.value == "").map((situation, id) => {
    return (
      <div style={{ margin: "3% 0%" }}>
        <h4>{situation?.indicator_name}</h4>
        <div style={{ color: "rgb(81, 82, 81)" }} dangerouslySetInnerHTML={{ __html: situation?.comment.replace(/\n/g, "<br />") }} />
      </div>
    )
  })

  return (
    <div>
      <div className="documents-container" style={{ textAlign: "left" }}>
        {parseHealthSituationInformation}
      </div>
    </div>
  )
}

HealthSituation.propTypes = {

}

export default HealthSituation;