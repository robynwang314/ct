import React from 'react'
import PropTypes from 'prop-types'
import { useCountryContext } from '../country-context.jsx'
import { Accordion } from 'react-bootstrap'
import NavigationButtons from "../Nav/navigation-buttons.jsx"
import "./documents.scss"

const ReopenEUTravel = ({ }) => {
  const { country, reopenEUComments } = useCountryContext()
  const [expanded, setExpanded] = React.useState(true)
  const allTravelInfo = reopenEUComments?.Travel

  // const skip = [2004, 2005, 2006, 2007]

  // const remove = allTravelInfo?.filter(c => !skip.includes(c.indicator_id))

  const parseTravelInfo = allTravelInfo?.map((travel_indicator, id) => {
    return (
      <>
        <Accordion defaultActiveKey={id} flush>
          <Accordion.Item eventKey={expanded ? id : 2000}>
            {/* <div className="comments-border" /> */}
            <Accordion.Header><h6>{travel_indicator?.indicator_name}</h6></Accordion.Header>
            <Accordion.Body><div style={{ color: "rgb(81, 82, 81)" }} dangerouslySetInnerHTML={{ __html: travel_indicator?.comment }} /></Accordion.Body>
          </Accordion.Item>
        </Accordion>
      </>
    )
  })

  return (
    <div>
      <br />
      <button onClick={() => setExpanded(!expanded)}>{expanded ? "collapse all" : "expand all"}</button>
      {/* <NavigationButtons /> */}
      {/* {country?.label ? <h2 style={{ fontWeight: 'bold' }}>Travel Information</h2> : ''} */}
      <div className="documents-container" style={{ textAlign: "left" }}>
        {/* <Accordion defaultActiveKey="0" flush> */}
        {parseTravelInfo}
        {/* </Accordion> */}
      </div>
    </div>
  )
}

ReopenEUTravel.propTypes = {

}

export default ReopenEUTravel;