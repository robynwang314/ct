import React from 'react';
import { render } from '@testing-library/react'
import App from './App';

describe("App", () => {
  it('renders', () => {
    const { container, debug } = render(<App />)
    debug(container)
  });
})