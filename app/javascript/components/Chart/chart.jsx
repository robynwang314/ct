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
import Loading from '../loading.jsx'

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

const Graphs = ({ }) => {
  const { countryInfo } = useCountryContext()
  const allData = countryInfo?.all_time_data

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

  for (let i = 0; i < allData?.length; i++) {
    const countryStats = allData[i];

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
    <div style={{ padding: '1%', minWidth: '65%', position: "relative" }}>
      <Chart data={data} options={options} />
    </div>
  )
}

export default Graphs
