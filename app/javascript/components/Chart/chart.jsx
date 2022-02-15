import React, { useEffect, useState } from 'react';
import {
  Chart as ChartJS,
  LinearScale,
  CategoryScale,
  BarElement,
  PointElement,
  LineElement,
  Legend,
  Tooltip,
  Title
} from 'chart.js';
import { Chart } from 'react-chartjs-2';
import { useCountryContext } from '../country-context.jsx'
import moment from 'moment';
import api from '../../api/api.js'

ChartJS.register(
  LinearScale,
  CategoryScale,
  BarElement,
  PointElement,
  LineElement,
  Legend,
  Tooltip,
  Title,
);

async function getAllTimeOWIDStats(country, string_parameterize) {
  const countryName = string_parameterize(country.label)
  return await api.countries.owid_stats(countryName)
}

const Graphs = ({ }) => {
  const { string_parameterize, country, setAllTimeOWIDstats } = useCountryContext()
  const [allCases, setAllCases] = useState([])

  useEffect(async () => {
    if (!country) return null;
    try {
      const alert = await getAllTimeOWIDStats(country, string_parameterize)
      if (alert && alert.data) {
        setAllTimeOWIDstats(alert.data)
        setAllCases(alert.data.data)
      }
    } catch (error) {
      console.log(error)
    }
  }, [country])

  let data = [];
  data['labels'] = [];
  data['datasets'] = [];
  data['datasets'][0] = {
    data: [],
    backgroundColor: "rgb(66, 135, 245)",
    label: 'New Deaths',
    type: "bar",
  };
  data['datasets'][1] = {
    data: [],
    backgroundColor: "rgba(242, 218, 223, 0.9)",
    borderColor: "rgba(0,0,0,0)",
    label: 'New Cases',
    type: "bar",
  };

  for (let i = 0; i < allCases.length; i++) {
    const countryStats = allCases[i];

    data['labels'][i] = moment(countryStats.date).format("MMM DD YY");
    data['datasets'][0].data[i] = countryStats.new_deaths;
    data['datasets'][1].data[i] = countryStats.new_cases;
  }

  const options = {
    responsive: true,
    scales: {
      x: {
        stacked: true,
        grid: {
          display: false,
        },
        ticks: {
          maxTicksLimit: 20
        },
        title: {
          display: true,
          text: 'Date',
          color: 'rgb(0, 0, 0)',
          font: {
            size: 16,
            lineHeight: 1.2,
          },
          padding: { top: 20, left: 0, right: 0, bottom: 0 }
        }
      },
      y: {
        grid: {
          drawTicks: false,
        },
        min: 0,
        title: {
          display: true,
          text: 'Cases',
          color: 'rgb(0, 0, 0)',
          font: {
            size: 16,
            lineHeight: 1.2,
          },
          padding: { top: 0, left: 0, right: 0, bottom: 20 }
        }
      },
    },
    elements: {
      point: {
        radius: 1.15,
        hoverRadius: 5,
        backgroundColor: "rgb(255, 99, 132)",
        borderColor: "rgb(255, 99, 132)",
      }
    },
    plugins: {
      tooltip: {
        titleAlign: 'center',
        displayColors: false,
      },
    },
  };

  return (
    <div style={{ padding: '1%', minWidth: '65%' }}>
      <Chart data={data} options={options} />
    </div>
  )
}

export default Graphs
