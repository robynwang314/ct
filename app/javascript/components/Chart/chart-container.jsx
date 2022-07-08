import React from 'react';
import PropTypes from 'prop-types'
import { useCountryContext } from '../country-context.jsx'
import "./charts.scss"
import Graphs from './chart.jsx'
import moment from 'moment';
import TravelAdvisory from "./../CountryInformation/travel-advisory.jsx"
import { Modal, Button } from 'react-bootstrap'
import ExpandedStats from "./../CountryInformation/expanded-stats.jsx"

function MoreStatsModal(props) {
  return (
    <Modal
      {...props}
      size="lg"
      aria-labelledby="contained-modal-title-vcenter"
      centered
    >
      <Modal.Header closeButton>
        <Modal.Title id="contained-modal-title-vcenter">
          <h4>Numbers and Statistics</h4>
        </Modal.Title>
      </Modal.Header>
      <Modal.Body>
        <ExpandedStats />
      </Modal.Body>
      <Modal.Footer>
        <Button onClick={props.onHide}>Close</Button>
      </Modal.Footer>
    </Modal>
  );
}

function handleTriggerModal(modalShow, setModalShow, todayStats) {
  return (
    <div style={{ marginTop: "25%", width: "100%", textAlign: "center" }}>
      {todayStats && <button onClick={() => setModalShow(true)} >
        {"View More Stats"}
      </button>}
      <MoreStatsModal
        show={modalShow}
        onHide={() => setModalShow(false)}
      />
    </div>
  )
}

export const StatsContainer = () => {
  const { countryInfo } = useCountryContext();
  const [modalShow, setModalShow] = React.useState(false);
  const todayStats = countryInfo?.todays_stats

  return (
    <div className="stats__container">
      <div className="stats__today-header">
        <h4 style={{ marginBottom: 0 }}>Latest Statistics</h4>
        <p className="stats__daily-numbers todays-date">
          {moment(todayStats?.last_updated_date).format("MMMM Do YYYY")}
        </p>
      </div>

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

      {handleTriggerModal(modalShow, setModalShow, todayStats)}
    </div>
  )
}

const ChartContainer = ({ }) => {

  return (
    <>
      <TravelAdvisory />
      <div className="chart-container">
        <Graphs />
        <StatsContainer />
      </div>
    </>
  )
}

// ChartContainer.propTypes = {
//   todayStats: PropTypes.any
// }

export default ChartContainer