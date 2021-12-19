import React from 'react';
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
  const { allTimeStats } = useCountryContext()

  let data = [];
  data['labels'] = [];
  data['datasets'] = [];
  data['datasets'][0] = {
    data: [],
    // data: [1, 2, 3, 3, 2, 1, 4],
    backgroundColor: "rgb(66, 135, 245)",
    label: 'New Deaths',
    type: "bar",
  };
  data['datasets'][1] = {
    data: [],
    // data: [1, 2, 10, 4, 6, 9, 10],
    backgroundColor: "rgba(242, 218, 223, 0.9)",
    borderColor: "rgba(0,0,0,0)",
    label: 'New Cases',
    type: "bar",
  };

  // const cases = allTimeStats.map(cases => cases.new_cases ? cases.new_cases : 0).sort()
  // const maxCases = Math.max(...cases)

  for (let i = 0; i < allTimeStats.length; i++) {
    const countryStats = allTimeStats[i];

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
