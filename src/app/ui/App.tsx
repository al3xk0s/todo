import './App.css';
import { AppBody } from './AppBody';
import { DITodoRepository, ITodoRepository, TodoRepository } from '../../entities/todo/services/TodoRepository';
import { NamedTodoFilter, TodoFilterName, timestampCompletedFirstTodoFilter, uncompletedOnlyTodoFilter, timestampTodoSorter, completedOnlyTodoFilter, DITodoFilters } from '../../entities/todo/services/TodoFilter';
import { IOC } from '../../shared/services/ServiceLocator';
import { store } from '../store';
import { Provider } from 'react-redux';

const bindDependencies = () => {
  const todoFilters : NamedTodoFilter[] = [
    { name: TodoFilterName.all, exec: timestampCompletedFirstTodoFilter },
    { name: TodoFilterName.uncompleted, exec: (todos) => uncompletedOnlyTodoFilter(timestampTodoSorter(todos)) },
    { name: TodoFilterName.completed, exec: (todos) => completedOnlyTodoFilter(timestampTodoSorter(todos)) },
  ];
  
  const todoRepository : ITodoRepository = new TodoRepository();
  
  IOC.bind(DITodoFilters, todoFilters);
  IOC.bind(DITodoRepository, todoRepository);

  console.log('bind dependencies')
}

bindDependencies();

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
