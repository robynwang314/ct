import axios from 'axios'

const countries = {
  index: () => {
    return axios({
      url: 'api/v1/countries',
      method: "GET",
      dataType: "json",
    });
  },
  show: (name) => {
    return axios({
      url: `api/v1/countries/${name}`,
      method: "GET",
      dataType: "json",
    });
  },
  travel_advisory: (name) => {
    return axios({
      url: `/api/v1/countries/travel_advisory`,
      method: "GET",
      dataType: "json",
      params: {
        name: name
      }
    });
  },
  owid_stats: (name) => {
    return axios({
      url: `api/v1/countries/owid_stats`,
      method: "GET",
      dataType: "json",
      params: {
        name: name
      }
    });
  },
  latest_owid: (name) => {
    return axios({
      url: `api/v1/countries/today_stats`,
      method: "GET",
      dataType: "json",
      params: {
        name: name
      }
    });
  },
  reopenEU: (name) => {
    return axios({
      url: `api/v1/countries/reopenEU`,
      method: "GET",
      dataType: "json",
      params: {
        name: name
      }
    });
  },
  embassy_information: (name) => {
    return axios({
      url: `api/v1/countries/embassy_information`,
      method: "GET",
      dataType: "json",
      params: {
        name: name
      }
    });
  },


}

const api = {
  countries
};

export default api