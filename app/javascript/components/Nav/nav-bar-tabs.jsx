import React from 'react'
import PropTypes from 'prop-types'
import { Nav, NavDropdown, Tab, Row } from 'react-bootstrap'
import Documents from "../Documents/documents.jsx"

function NavBarTabs({ ...props }) {


  const handleSelect = (eventKey) => alert(`selected ${eventKey}`);

  return (
    <Tab.Container id="left-tabs-example" defaultActiveKey="2">
      <Row>
        <Nav variant="pills" /* onSelect={handleSelect}*/ sticky="top">
          <Nav.Item>
            <Nav.Link eventKey="1">
              Health Situation
            </Nav.Link>
          </Nav.Item>
          <Nav.Item>
            <Nav.Link eventKey="2">
              Travel Information
            </Nav.Link>
          </Nav.Item>
          <Nav.Item>
            <Nav.Link eventKey="3">
              General Measures
            </Nav.Link>
          </Nav.Item>
          <Nav.Item>
            <Nav.Link eventKey="4">
              Mandates
            </Nav.Link>
          </Nav.Item>
          <Nav.Item>
            <Nav.Link eventKey="5">
              Avaliable Services
            </Nav.Link>
          </Nav.Item>
          <Nav.Item>
            <Nav.Link eventKey="6">
              Further Information
            </Nav.Link>
          </Nav.Item>
          <NavDropdown title="Jump to Section" id="nav-dropdown" className="justify-content-end">
            <NavDropdown.Item eventKey="4.1">Action</NavDropdown.Item>
            <NavDropdown.Item eventKey="4.2">Another action</NavDropdown.Item>
            <NavDropdown.Item eventKey="4.3">Something else here</NavDropdown.Item>
            <NavDropdown.Divider />
            <NavDropdown.Item eventKey="4.4">Separated link</NavDropdown.Item>
          </NavDropdown>
        </Nav>
      </Row>
      <Row>
        <Tab.Content>
          <Tab.Pane eventKey="1">
            <div>hello</div>
          </Tab.Pane>
          <Tab.Pane eventKey="2">
            {props.country?.label ? <Documents /> :
              <h2 style={{ fontWeight: 'bold', marginTop: "3%" }}>No travel information to show</h2>}
          </Tab.Pane>
        </Tab.Content>
      </Row>
    </Tab.Container>
  );
}


export default NavBarTabs;