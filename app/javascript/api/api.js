import axios from 'axios'

const countries = {
  index: () => {
    return axios({
      url: 'api/v1/countries',
      method: "GET",
      dataType: "json",
    })
  }
}

const api = {
  countries
};

export default api