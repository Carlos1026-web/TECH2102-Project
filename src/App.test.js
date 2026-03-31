import { render, screen } from '@testing-library/react';
import App from './App';

test('renders group information', () => {
  render(<App />);
  const linkElement = screen.getByText(/TECH 2102 - Group 13 - Derek, Kyrian, Renato/i);
  expect(linkElement).toBeInTheDocument();
});
