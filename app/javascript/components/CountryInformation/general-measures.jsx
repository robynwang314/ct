import React from 'react'
import { useCountryContext } from '../country-context.jsx'
import { Accordion } from 'react-bootstrap'
import "./documents.scss"

const GeneralMeasures = ({ }) => {
  const { countryInfo } = useCountryContext()
  const reopenEUComments = countryInfo?.reopen_eu
  const allHealthInfo = reopenEUComments && reopenEUComments["Coronavirus Measures"]

  const parseGeneralMeasures = allHealthInfo?.map((measure, id) => {
    return (
      <>
        <Accordion key={id} defaultActiveKey={id} flush>
          <Accordion.Item eventKey={id}>
            <Accordion.Header><h6>{measure?.indicator_name}</h6></Accordion.Header>
            <Accordion.Body><div style={{ color: "rgb(81, 82, 81)" }} dangerouslySetInnerHTML={{ __html: measure?.comment }} /></Accordion.Body>
          </Accordion.Item>
        </Accordion>
      </>
    )
  })

  return (
    <div>
      <br />
      <div className="documents-container" style={{ textAlign: "left" }}>
        {parseGeneralMeasures}
      </div>
    </div>
  )
}

GeneralMeasures.propTypes = {

}

export default GeneralMeasures;