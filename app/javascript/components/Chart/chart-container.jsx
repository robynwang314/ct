import React, { useState } from 'react';
import PropTypes from 'prop-types'
import { useCountryContext } from '../country-context.jsx'
import "./charts.scss"
import Graphs from './chart.jsx'
import moment from 'moment';

export const StatsContainer = ({ todayStats }) => {
  return (
    <div className="stats__container">
      <span className="stats__today-header">
        Today's Statistics
        <p className="stats__daily-numbers todays-date">
          {moment(todayStats?.date).format("MMMM Do YYYY")}
        </p>
      </span>

      <div className="stats__daily-highlights">
        New Cases: <span className="stats__daily-numbers"> {todayStats?.new_cases} </span>
      </div>
      <div className="stats__daily-highlights">
        New Deaths: <span className="stats__daily-numbers"> {todayStats?.new_deaths} </span>
      </div>
      <div className="stats__daily-highlights">
        Total Cases: <span className="stats__daily-numbers"> {todayStats?.total_cases} </span>
      </div>
      <div className="stats__daily-highlights">
        Total Deaths: <span className="stats__daily-numbers"> {todayStats?.total_deaths} </span>
      </div>
    </div>
  )
}

const ChartContainer = ({ }) => {
  const { todayStats } = useCountryContext()

  return todayStats && (
    <div className="chart-container">
      <Graphs />
      <StatsContainer todayStats={todayStats} />
    </div>
  )
}

ChartContainer.propTypes = {
  todayStats: PropTypes.any
}

export default ChartContainer