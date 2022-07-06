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
}

const api = {
  countries
};

export default api