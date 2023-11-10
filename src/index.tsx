/** Импортировать why-did-you-render в начале файла */
import "./wdyr";


import React from 'react';
import ReactDOM from 'react-dom/client';
import './index.css';
import App from './app/ui/App';

const root = ReactDOM.createRoot(
  document.getElementById('root') as HTMLElement
);

root.render(
  
      <App />
  
);

