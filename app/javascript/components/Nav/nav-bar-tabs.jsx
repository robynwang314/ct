import React, { useEffect, useState } from 'react'
import PropTypes from 'prop-types'
import { Nav, Tab, Row } from 'react-bootstrap'
import HealthSituation from "../CountryInformation/health-situation.jsx"
import Documents from "../CountryInformation/documents.jsx"
import GeneralMeasures from "../CountryInformation/general-measures.jsx"
import Mandates from "../CountryInformation/mandates.jsx"
import Services from "../CountryInformation/open-establishments.jsx"
import FurtherInformation from "../CountryInformation/further-info.jsx"
import { useCountryContext } from '../country-context.jsx'
import api from '../../api/api.js'

export const TAB_ITEMS = ["Health Situation", "Travel Information", "General Measures", "Mandates", "Open Establishments", "Further Information"]

async function getReopenEUComments(country, string_parameterize) {
  const countryName = string_parameterize(country.label)
  return await api.countries.reopenEU(countryName)
}

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
  const { country, string_parameterize, setReopenEUComments } = useCountryContext()
  const handleSelect = (eventKey) => alert(`selected ${eventKey}`);

  useEffect(async () => {
    if (!country) return null;
    try {
      const comments = await getReopenEUComments(country, string_parameterize)
      if (comments && comments.data) {
        setReopenEUComments(comments.data)
      }
    } catch (error) {
      console.log(error)
    }
    // finally {

    // }
  }, [country])

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
          <Tab.Pane eventKey="2">
            {props.country?.label ? <GeneralMeasures /> :
              <h2 style={{ fontWeight: 'bold', marginTop: "3%" }}>No general measures to show</h2>}
          </Tab.Pane>
          <Tab.Pane eventKey="3">
            {props.country?.label ? <Mandates /> :
              <h2 style={{ fontWeight: 'bold', marginTop: "3%" }}>No mandate information to show</h2>}
          </Tab.Pane>
          <Tab.Pane eventKey="4">
            {props.country?.label ? <Services /> :
              <h2 style={{ fontWeight: 'bold', marginTop: "3%" }}>No service information to show</h2>}
          </Tab.Pane>
          <Tab.Pane eventKey="5">
            {props.country?.label ? <FurtherInformation /> :
              <h2 style={{ fontWeight: 'bold', marginTop: "3%" }}>No further information to show</h2>}
          </Tab.Pane>
        </Tab.Content>
      </Row>
    </Tab.Container>
  );
}


export default NavBarTabs;