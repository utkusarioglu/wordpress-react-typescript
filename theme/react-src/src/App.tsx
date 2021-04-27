import React from 'react';
import logo from './logo.svg';
import './App.css';

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <h2 dangerouslySetInnerHTML={{ __html: window.config.pageTitle }} />
        <a href="/wp-admin">visit wp-admin</a>
      </header>
    </div>
  );
}

export default App;
