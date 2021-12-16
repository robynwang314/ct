import React from 'react';
import PropTypes from 'prop-types'
import { useCountryContext } from '../country-context.jsx'
import "./charts.scss"

const ChartContainer = ({ }) => {
  const { stats } = useCountryContext()
  // console.log(stats)

  return (
    <div className="chart-container">
      <div>
        Date: {stats?.date}
      </div>
      <div>
        New Cases: {stats?.new_cases}
      </div>
      <div>
        New Deaths: {stats?.new_deaths}
      </div>
      <div>
        Total Cases: {stats?.total_cases}
      </div>
      <div>
        Total Deaths: {stats?.total_deaths}
      </div>
    </div>
  )
}

ChartContainer.propTypes = {

}

export default ChartContainer