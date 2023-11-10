import { createSelector } from "@reduxjs/toolkit";
import { RootState } from "../../../../app/store";
import { getTodoFilterByIndex } from "../reducers/todoFilterReducer";

export const todosSelector = createSelector(
  (state: RootState) => state.todos.state.data,
  (data) => Array.from(Object.values(data ?? {})),
);

export const loadingTodoSelector = (state: RootState) => !state.todos.state.isComplete;

export const todoFilterSelector = createSelector(
  (state: RootState) => state.todos.filter,
  (filter) => getTodoFilterByIndex(filter.currentIndex),
);

export const filtredTodosSelector = createSelector(
  [ todosSelector, todoFilterSelector ],
  (todos, currentFilter) => currentFilter.exec(todos),
);

export const savedCreateTodoTitleSelector = (s: RootState) => s.todos.createTodoTitle.value;
