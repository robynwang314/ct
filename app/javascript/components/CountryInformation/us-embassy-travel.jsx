import React from 'react'
import PropTypes from 'prop-types'
import { useCountryContext } from '../country-context.jsx'
import { Accordion } from 'react-bootstrap'
import NavigationButtons from "../Nav/navigation-buttons.jsx"
import "./documents.scss"

const USEmbassyTravel = ({ }) => {
  const { country, embassyComments, collapsed, expanded } = useCountryContext()

  const parseTravelInfo = Object.keys(embassyComments)?.map((travel_indicator, id) => {
    if (travel_indicator == "Country Specific Information" || travel_indicator == "Important Information") return;

    return (
      <>
        <Accordion defaultActiveKey={id} flush>
          <Accordion.Item eventKey={id}>
            <Accordion.Header><h6>{travel_indicator}</h6></Accordion.Header>
            <Accordion.Body><div style={{ color: "rgb(81, 82, 81)" }} dangerouslySetInnerHTML={{ __html: embassyComments[travel_indicator] }} /></Accordion.Body>
          </Accordion.Item>
        </Accordion>
      </>
    )
  })

  const formattedHTML = embassyComments["Country Specific Information"]?.replaceAll('\n', '\n\n')

  return (
    <div>
      <br />
      <div className="embassy-info-container" style={{ textAlign: "left" }}>
        <h3 className="country-name__specific-info">Traveling to {country.label}</h3>
        <br />
        <div style={{ color: "rgb(81, 82, 81)" }} dangerouslySetInnerHTML={{ __html: formattedHTML }} />
        <br />
        {parseTravelInfo}
      </div>
    </div>
  )
}

USEmbassyTravel.propTypes = {

}

export default USEmbassyTravel;