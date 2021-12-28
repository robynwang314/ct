import React from 'react'
import PropTypes from 'prop-types'
import { useCountryContext } from '../country-context.jsx'
import { ListGroup, Badge } from 'react-bootstrap'
import "./documents.scss"

const HealthSituation = ({ }) => {
  const { countryInformation } = useCountryContext()
  const allHealthInfo = countryInformation["Health Situation"]

  const parseHealthSituationNumbers = allHealthInfo?.filter((data) => data.value !== "").map((situation, id) => {
    return (
      <>
        <ListGroup.Item
          as="li"
          className="d-flex justify-content-between align-items-start"
        >
          <div className="ms-2 me-auto">
            <div className="fw-bold">{situation?.indicator_name}</div>
            <div style={{ color: "rgb(81, 82, 81)", fontSize: "12px", fontStyle: "italic" }} dangerouslySetInnerHTML={{ __html: situation?.comment.replace(/\n/g, "<br />") }} />
          </div>
          <Badge variant="primary" pill>
            {situation?.value}
          </Badge>
        </ListGroup.Item>
      </>
    )
  })

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
      <br />
      <div className="documents-container" style={{ textAlign: "left" }}>
        <div style={{ margin: "1% 0% 1.25% 0%" }}>
          <h4>Numbers and Statistics</h4>
        </div>
        <ListGroup as="ul">
          {parseHealthSituationNumbers}
        </ListGroup>

        {parseHealthSituationInformation}
      </div>
    </div>
  )
}

HealthSituation.propTypes = {

}

export default HealthSituation;