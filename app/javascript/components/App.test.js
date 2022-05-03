import React from 'react';
import { render, act, waitFor, fireEvent } from '@testing-library/react'
import userEvent from "@testing-library/user-event";


import App from './App';
import api from '../api/api.js'
import MockedValues from './mockedConsts.js'

jest.mock(
  "./Chart/chart.jsx",
  () =>
    function Chart() {
      return <div>{"Chart"}</div>;
    }
);

jest.mock(
  './Chart/chart-container.jsx',
  () =>
    function StatsContainer() {
      return <div>{"stats container"}</div>;
    }
);

jest.mock(
  "./Nav/nav-bar-tabs.jsx",
  () =>
    function NavBarTabs() {
      return <div>{"Nav Bar Tabs"}</div>
    }
)

jest.mock("axios");

describe("App", () => {
  it('renders empty state', () => {
    const { container } = render(<App />)
    expect(container).toMatchSnapshot()
  });

  describe("MainDocument", () => {
    describe("#getCountries", () => {
      let mockedPromise;

      beforeEach(() => {
        jest.resetAllMocks
      })

      afterEach(() => {
        jest.clearAllMocks();
      })

      it("succeeds", async () => {
        mockedPromise = Promise.resolve({ data: MockedValues.countries });
        jest.spyOn(api.countries, "index").mockReturnValue(mockedPromise);

        render(<App />)

        await act(() => mockedPromise)
        expect(api.countries.index).toBeCalledTimes(1);
      })

      it("console.log errors", async () => {
        mockedPromise = Promise.reject("rejected promise");
        jest.spyOn(api.countries, "index").mockReturnValue(mockedPromise);
        jest.spyOn(console, 'log');

        render(<App />)

        try {
          expect(api.countries.index).toBeCalledTimes(1);
        } catch {
          expect(console.log).toHaveBeenCalled()
        }
      })
    })

    describe("#getAlertStatus", () => {
      let mockedPromise;

      beforeEach(() => {
        mockedPromise = Promise.resolve({ data: MockedValues.countries });
        jest.spyOn(api.countries, "index").mockResolvedValue(mockedPromise);
      })

      afterEach(() => {
        jest.clearAllMocks();
      })

      it("gets the alert status", async () => {
        const newMockedPromise = Promise.resolve({ data: { message: "mock travel_advisory alert" } });
        jest.spyOn(api.countries, 'travel_advisory').mockReturnValue(newMockedPromise)

        const { container, getByText } = render(<App />)

        await act(() => mockedPromise)
        expect(api.countries.index).toBeCalledTimes(1);


        const selectElement = getByText("Select a country");
        userEvent.click(selectElement)

        await waitFor(() => {
          expect(getByText("United States")).toBeInTheDocument()
          expect(container).toMatchSnapshot()
        })

        fireEvent.keyDown(selectElement, { keyCode: 40 })
        fireEvent.keyDown(selectElement, { keyCode: 40 })
        fireEvent.keyDown(selectElement, { keyCode: 13 });

        expect(api.countries.travel_advisory).toHaveBeenCalledWith("Austria");

        await act(() => newMockedPromise)

        expect(getByText("mock travel_advisory alert")).toBeInTheDocument()

        expect(container).toMatchSnapshot()
      })
    })
  })
})