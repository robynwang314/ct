import React, { useState } from 'react';
import PropTypes from 'prop-types'
import { useCountryContext } from '../country-context.jsx'
import "./charts.scss"
import Graphs from './chart.jsx'


const ChartContainer = ({ }) => {
  const { todayStats, allTimeStats } = useCountryContext()

  return todayStats && (
    <div className="chart-container">
      <Graphs />

      <div style={{ minWidth: '30%', display: 'flex', flexDirection: 'column', alignItems: 'flex-start', fontWeight: 'bold', paddingLeft: '2.5%', borderLeft: 'solid 4px lightgrey' }}>

        <span style={{ marginTop: '4%', width: "100%" }}>
          Today's Statistics
          <p style={{ fontWeight: '500', fontStyle: 'italic', margin: 0 }}>{todayStats?.date}</p>
        </span>
        <div style={{ lineHeight: 4 }}>
          New Cases: {todayStats?.new_cases}
        </div>
        <div style={{ lineHeight: 4 }}>
          New Deaths: {todayStats?.new_deaths}
        </div>
        <div style={{ lineHeight: 4 }}>
          Total Cases: {todayStats?.total_cases}
        </div>
        <div style={{ lineHeight: 4 }}>
          Total Deaths: {todayStats?.total_deaths}
        </div>

      </div>
    </div>
  )
}

ChartContainer.propTypes = {

}

export default ChartContainer