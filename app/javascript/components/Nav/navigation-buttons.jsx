import React from 'react'
import PropTypes from 'prop-types'
import { ButtonGroup, Button } from 'react-bootstrap'

const NavigationButtons = () => {

  return (
    <ButtonGroup aria-label="Basic example">
      <Button variant="dark" style={{ borderRight: 'solid 3px white' }}><i className='fa fa-angle-double-up fa-2x' /> </Button>
      <Button variant="dark" style={{ width: "75px", padding: "0px", textAlign: "center" }}>Collapse All</Button>
    </ButtonGroup>
  )
}

export default NavigationButtons;