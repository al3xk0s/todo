import { configureStore } from "@reduxjs/toolkit";
import { todosReducer } from "../features/todo/redux/reducers/todoReducer";
import { modalReducer, openModal } from "../shared/ui/modal/modalReducer";
import { DITodoRepository, ITodoRepository, TodoRepository } from '../entities/todo/services/TodoRepository';
import { NamedTodoFilter, TodoFilterName, timestampCompletedFirstTodoFilter, uncompletedOnlyTodoFilter, timestampTodoSorter, completedOnlyTodoFilter, DITodoFilters } from '../entities/todo/services/TodoFilter';
import { IOC } from '../shared/services/ServiceLocator';
import { DIStorage, LocalStorage } from '../shared/services/Storage';

const reducer = {
  todos: todosReducer,
  modal: modalReducer,
};

const bindDependencies = () => {
  const todoFilters : NamedTodoFilter[] = [
    { name: TodoFilterName.all, exec: timestampCompletedFirstTodoFilter },
    { name: TodoFilterName.uncompleted, exec: (todos) => uncompletedOnlyTodoFilter(timestampTodoSorter(todos)) },
    { name: TodoFilterName.completed, exec: (todos) => completedOnlyTodoFilter(timestampTodoSorter(todos)) },
  ];
  
  const todoRepository = new TodoRepository();

  const storage = new LocalStorage();
  
  IOC.bind(DITodoFilters, todoFilters);
  IOC.bind(DITodoRepository, todoRepository);
  IOC.bind(DIStorage, storage)

  console.log('bind dependencies')
}

bindDependencies();

export const store = configureStore({
  reducer,
  preloadedState: (() => {
    const data = IOC.findByToken(DIStorage).load();
    if(data == null) return {};

    const {filter, createTodoTitle} = data;

    return {todos: {filter, createTodoTitle}};
  })(),
  middleware: (getDefaultMiddleware) => {
    return getDefaultMiddleware({
      serializableCheck: {
        ignoredActions: [openModal.type],
        ignoredPaths: ['modal.props'],
      },
    })
  },
});

store.subscribe(() => {
  IOC.findByToken(DIStorage).save(store.getState().todos);
})

export type RootState = ReturnType<typeof store.getState>;
export type AppDispatch = typeof store.dispatch;
export type RootReducerType = typeof reducer;
export type AsyncThunkConfigType = { rejectValue: string, state: RootState };
