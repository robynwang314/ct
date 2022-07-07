import React from 'react'
import PropTypes from 'prop-types'
import { Nav, Tab, Row } from 'react-bootstrap'
import HealthSituation from "../CountryInformation/health-situation.jsx"
import USEmbassyTravel from "../CountryInformation/us-embassy-travel.jsx"
import ReopenEUTravel from "../CountryInformation/reopenEU-travel.jsx"
import GeneralMeasures from "../CountryInformation/general-measures.jsx"
import Mandates from "../CountryInformation/mandates.jsx"
import Services from "../CountryInformation/open-establishments.jsx"
import FurtherInformation from "../CountryInformation/further-info.jsx"

export const TAB_ITEMS = ["Health Situation", "Travel Information (US Embassy)", "Travel Information (ReOpen EU)", "General Measures", "Mandates", "Open Establishments", "Further Information"]

const NavButtons = () => {
  return TAB_ITEMS.map((item, id) => (
    <Nav.Item key={id}>
      <Nav.Link eventKey={id}>
        {item}
      </Nav.Link>
    </Nav.Item>
  ))
}

function NavBarTabs({ ...props }) {
  const handleSelect = (eventKey) => alert(`selected ${eventKey}`);
  return (
    <Tab.Container id="left-tabs-example" defaultActiveKey="1">
      <Row>
        <Nav variant="pills" /* onSelect={handleSelect}*/ sticky="top">
          <NavButtons />
        </Nav>
      </Row>
      <Row>
        <Tab.Content>
          <Tab.Pane eventKey="0">
            {props.country?.label ? <HealthSituation /> :
              <h2 style={{ fontWeight: 'bold', marginTop: "3%" }}>No health situation to show</h2>}
          </Tab.Pane>
          <Tab.Pane eventKey="1">
            {props.country?.label ? <USEmbassyTravel /> :
              <h2 style={{ fontWeight: 'bold', marginTop: "3%" }}>No travel information to show</h2>}
          </Tab.Pane>
          <Tab.Pane eventKey="2">
            {props.country?.label ? <ReopenEUTravel /> :
              <h2 style={{ fontWeight: 'bold', marginTop: "3%" }}>No travel information to show</h2>}
          </Tab.Pane>
          <Tab.Pane eventKey="3">
            {props.country?.label ? <GeneralMeasures /> :
              <h2 style={{ fontWeight: 'bold', marginTop: "3%" }}>No general measures to show</h2>}
          </Tab.Pane>
          <Tab.Pane eventKey="4">
            {props.country?.label ? <Mandates /> :
              <h2 style={{ fontWeight: 'bold', marginTop: "3%" }}>No mandate information to show</h2>}
          </Tab.Pane>
          <Tab.Pane eventKey="5">
            {props.country?.label ? <Services /> :
              <h2 style={{ fontWeight: 'bold', marginTop: "3%" }}>No service information to show</h2>}
          </Tab.Pane>
          <Tab.Pane eventKey="6">
            {props.country?.label ? <FurtherInformation /> :
              <h2 style={{ fontWeight: 'bold', marginTop: "3%" }}>No further information to show</h2>}
          </Tab.Pane>
        </Tab.Content>
      </Row>
    </Tab.Container>
  );
}


export default NavBarTabs;