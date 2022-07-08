import React from 'react'
import PropTypes from 'prop-types'
import { Nav, Tab, Row, } from 'react-bootstrap'
import ChartContainer from '../Chart/chart-container.jsx'
import HealthSituation from "../CountryInformation/health-situation.jsx"
import USEmbassyTravel from "../CountryInformation/us-embassy-travel.jsx"
import ReopenEUTravel from "../CountryInformation/reopenEU-travel.jsx"
import GeneralMeasures from "../CountryInformation/general-measures.jsx"
import Mandates from "../CountryInformation/mandates.jsx"
import Services from "../CountryInformation/open-establishments.jsx"
import FurtherInformation from "../CountryInformation/further-info.jsx"

export const TAB_ITEMS = ["Overview", "Health Situation", "US Embassy Information", "ReOpen EU Information", "General Measures", "Mandates", "Open Establishments", "Further Information"]

const NavButtons = () => {
  return TAB_ITEMS.map((item) => (
    <Nav.Item key={item}>
      <Nav.Link eventKey={item}>
        {item}
      </Nav.Link>
    </Nav.Item>
  ))
}

function renderTabPane(content, tab, props) {

  return (
    <Tab.Pane eventKey={tab}>
      {props.country?.label ? <>{content}</> : tab == TAB_ITEMS[0] ? <ChartContainer /> :
        <h2 style={{ fontWeight: 'bold', marginTop: "3%" }}>No {tab} situation to show</h2>}
    </Tab.Pane>
  )
}

const TabPanes = ({ tab, ...props }) => {
  let content;

  switch (tab) {
    case TAB_ITEMS[1]:
      content = <HealthSituation />
      break
    case TAB_ITEMS[2]:
      content = <USEmbassyTravel />
      break
    case TAB_ITEMS[3]:
      content = <ReopenEUTravel />
      break
    case TAB_ITEMS[4]:
      content = <GeneralMeasures />
      break
    case TAB_ITEMS[5]:
      content = <Mandates />
      break
    case TAB_ITEMS[6]:
      content = <Services />
      break
    case TAB_ITEMS[7]:
      content = <FurtherInformation />
      break
    default:
      content = <ChartContainer />
  }

  return renderTabPane(content, tab, props)
}

function NavBarTabs({ ...props }) {
  return (
    <Tab.Container id="left-tabs-example" defaultActiveKey={TAB_ITEMS[0]}>
      <Row style={{ maxHeight: "100%" }}>
        <Nav variant="pills" sticky="top">
          <NavButtons />
        </Nav>
      </Row>
      <Row>
        <Tab.Content>
          {TAB_ITEMS.map((tab) => {
            return (
              <TabPanes key={tab} tab={tab} {...props} />
            )
          }
          )}
        </Tab.Content>
      </Row>
    </Tab.Container>
  );
}


export default NavBarTabs;