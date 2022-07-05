import React from 'react'
import { hot } from 'react-hot-loader/root';
import { CountrySelectionProvider } from './country-context.jsx'
import { QueryClient, QueryClientProvider } from "react-query";

import MainDocument from './main-document.jsx';
import "./app.scss"

const queryClient = new QueryClient();

const App = () => {

  return (
    <div className="app-container">
      <QueryClientProvider client={queryClient}>
        <CountrySelectionProvider>
          <MainDocument />
        </CountrySelectionProvider>
      </QueryClientProvider>
    </div>
  )
}

export default hot(App)

