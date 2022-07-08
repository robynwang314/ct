import React from 'react'
import PropTypes from 'prop-types'
import { useCountryContext } from '../country-context.jsx'
import { ListGroup, Badge } from 'react-bootstrap'
import "./documents.scss"

const ExpandedStats = ({ }) => {
  const { countryInfo } = useCountryContext()
  const reopenEUComments = countryInfo?.reopen_eu
  const allHealthInfo = reopenEUComments && reopenEUComments["Health Situation"]

  const parseHealthSituationNumbers = allHealthInfo?.filter((data) => data.value !== "").map((situation, id) => {
    return (
      <div key={id}>
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
      </div>
    )
  })

  return (
    <div>
      <div className="documents-container" style={{ marginTop: "3%", textAlign: "left" }}>
        <ListGroup as="ul">
          {parseHealthSituationNumbers}
        </ListGroup>
      </div>
    </div>
  )
}

ExpandedStats.propTypes = {

}

export default ExpandedStats;