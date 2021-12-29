// Run this example by adding <%= javascript_pack_tag 'index' %> to the head of your layout file,
// like app/views/layouts/application.html.erb. All it does is render <div>Hello React</div> at the bottom
// of the page.

import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'
import App from '../components/App'
import 'bootstrap/dist/css/bootstrap.min.css';
import 'font-awesome/css/font-awesome.min.css';
import 'react-hot-loader'

document.addEventListener('DOMContentLoaded', () => {
  const Something = () => {
    return (
      <div>HELLLOOOO</div>
    )
  }

  ReactDOM.render(
    <>
      {/* <Something /> */}
      <App />
    </>
    ,
    document.body.appendChild(document.createElement('div')),
  )
})
