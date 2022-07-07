import React from 'react'
import PropTypes from 'prop-types'
import { useCountryContext } from '../country-context.jsx'
import { Accordion } from 'react-bootstrap'
import "./documents.scss"

const FurtherInformation = ({ }) => {
  const { countryInfo } = useCountryContext()
  const allHealthInfo = countryInfo?.reopen_eu?.Information

  const parseReopenEUComments = allHealthInfo?.map((information, id) => {
    return (
      <>
        <Accordion key={id} defaultActiveKey={id} flush>
          <Accordion.Item eventKey={id}>
            <Accordion.Header><h6>{information?.indicator_name}</h6></Accordion.Header>
            <Accordion.Body><div style={{ color: "rgb(81, 82, 81)" }} dangerouslySetInnerHTML={{ __html: information?.comment }} /></Accordion.Body>
          </Accordion.Item>
        </Accordion>
      </>
    )
  })

  return (
    <div>
      <br />
      <div className="documents-container" style={{ textAlign: "left" }}>
        {parseReopenEUComments}
      </div>
    </div>
  )
}

FurtherInformation.propTypes = {

}

export default FurtherInformation;