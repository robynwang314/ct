import React from 'react'
import PropTypes from 'prop-types'
import { useCountryContext } from '../country-context.jsx'
import { Accordion } from 'react-bootstrap'
import "./documents.scss"

const Services = ({ }) => {
  const { countryInfo } = useCountryContext()
  const allHealthInfo = countryInfo?.reopen_eu?.Services

  const parseServices = allHealthInfo?.map((service, id) => {
    return (
      <>
        <Accordion key={id} defaultActiveKey={id} flush>
          <Accordion.Item eventKey={id}>
            <Accordion.Header><h6>{service?.indicator_name}</h6></Accordion.Header>
            <Accordion.Body><div style={{ color: "rgb(81, 82, 81)" }} dangerouslySetInnerHTML={{ __html: service?.comment }} /></Accordion.Body>
          </Accordion.Item>
        </Accordion>
      </>
    )
  })

  return (
    <div>
      <br />
      <div className="documents-container" style={{ textAlign: "left" }}>
        {parseServices}
      </div>
    </div>
  )
}

Services.propTypes = {

}

export default Services;