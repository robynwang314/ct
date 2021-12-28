import React from 'react'
import PropTypes from 'prop-types'
import { Nav, Tab, Row } from 'react-bootstrap'
import HealthSituation from "../CountryInformation/health-situation.jsx"
import Documents from "../CountryInformation/documents.jsx"


export const TAB_ITEMS = ["Health Situation", "Travel Information", "General Measures", "Mandates", "Open Establishments", "Further Information"]

const NavButtons = () => {
  return TAB_ITEMS.map((item, id) => (
    <Nav.Item>
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
            {props.country?.label ? <Documents /> :
              <h2 style={{ fontWeight: 'bold', marginTop: "3%" }}>No travel information to show</h2>}
          </Tab.Pane>
        </Tab.Content>
      </Row>
    </Tab.Container>
  );
}


export default NavBarTabs;