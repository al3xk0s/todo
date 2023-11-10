import './App.css';
import { AppBody } from './AppBody';
import { store } from '../store';
import { Provider } from 'react-redux';

function App() {
  return (
    <Provider store={store}>
      <div id='app' className="App">
        <AppBody />
      </div>
    </Provider>
  );
}

export default App;
