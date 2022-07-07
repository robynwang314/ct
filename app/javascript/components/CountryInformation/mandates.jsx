import React from 'react'
import { useCountryContext } from '../country-context.jsx'
import { Accordion } from 'react-bootstrap'
import "./documents.scss"

const Mandates = ({ }) => {
  const { countryInfo } = useCountryContext()
  const reopenEUComments = countryInfo?.reopen_eu
  const allHealthInfo = reopenEUComments && reopenEUComments["Health and Safety"]

  const parseMandates = allHealthInfo?.map((mandate, id) => {
    return (
      <>
        <Accordion key={id} defaultActiveKey={id} flush>
          <Accordion.Item eventKey={id}>
            <Accordion.Header><h6>{mandate?.indicator_name}</h6></Accordion.Header>
            <Accordion.Body><div style={{ color: "rgb(81, 82, 81)" }} dangerouslySetInnerHTML={{ __html: mandate?.comment }} /></Accordion.Body>
          </Accordion.Item>
        </Accordion>
      </>
    )
  })

  return (
    <div>
      <br />
      <div className="documents-container" style={{ textAlign: "left" }}>
        {parseMandates}
      </div>
    </div>
  )
}

Mandates.propTypes = {

}

export default Mandates;