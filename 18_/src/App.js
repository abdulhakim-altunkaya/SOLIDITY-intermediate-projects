function App() {
  const connectMetamask = () => {
    return;
  }
  const connectContract = () => {
    return;
  }
  return (
    <div className="App">
      <header className="App-header">
        <button onClick={connectMetamask}>CONNECT TO METAMASK</button>
        <p id="areaMetamask"></p>
        <button onClick={connectContract}>CONNECT TO CONTRACT</button>
        <p id="areaConnection"></p>
      </header>
    </div>
  );
}

export default App;

