]import React, { useState } from 'react';
import Web3 from 'web3';
import { ambulanceAbi } from './abi/abis';
import './App.css';
const web3 = new Web3(Web3.givenProvider);
import { contractAddress } from './Handler/ContractAddressHandler'

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <p>
          Edit <code>src/App.js</code> and save to reload.
        </p>
        <a
          className="App-link"
          href="https://reactjs.org"
          target="_blank"
          rel="noopener noreferrer"
        >
          Learn React
        </a>
      </header>
    </div>
  );
}

export default App;
