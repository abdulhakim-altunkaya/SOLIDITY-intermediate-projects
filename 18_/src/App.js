import logo from './logo.svg';

function App {
  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <p>
          Edit <code>src/App.js</code> and save to reload.
        </p>
        <button onClick={}=></button>
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


<div id="readArea">
  <button onClick="connectMetamask">CONNECT TO METAMASK</button>
  <p id="userArea">Status: Not connected to Metamask</p>
  <button onclick="connectContract">CONNECT TO CONTRACT</button>
  <p id="contractArea">Status: Not connected to Contract</p>
  <button onclick="mintTokens2">MINT TOKENS</button>
</div>