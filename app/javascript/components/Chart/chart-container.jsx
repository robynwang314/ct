import React from 'react';
import PropTypes from 'prop-types'
import { useCountryContext } from '../country-context.jsx'
import "./charts.scss"
import Graphs from './chart.jsx'
import moment from 'moment';

export const StatsContainer = () => {
  const { countryInfo } = useCountryContext();

  const todayStats = countryInfo?.todays_stats

  return (
    <div className="stats__container">
      <span className="stats__today-header">
        <h4 style={{ marginBottom: 0 }}>Latest Statistics</h4>
        <p className="stats__daily-numbers todays-date">
          {moment(todayStats?.last_updated_date).format("MMMM Do YYYY")}
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

  return (
    <div className="chart-container">
      <Graphs />
      <StatsContainer />
    </div>
  )
}

// ChartContainer.propTypes = {
//   todayStats: PropTypes.any
// }

export default ChartContainer