import { createSlice } from "@reduxjs/toolkit";
import { IOC } from "../../../../shared/services/ServiceLocator";
import { DITodoFilters } from "../../../../entities/todo/services/TodoFilter";

export interface FilterTodoState {
  currentIndex: number,
}

const initialState : FilterTodoState = {
  currentIndex: 0,
}

const sortTodoSlice = createSlice({
  name: 'todos/sort',
  initialState,
  reducers: {
    nextSorter: (state) => {
      state.currentIndex = (state.currentIndex + 1) % IOC.findByToken(DITodoFilters).length;      
    },
    prevSorter: (state) => {
      const newIndex = state.currentIndex - 1 >= 0 ? state.currentIndex - 1 : IOC.findByToken(DITodoFilters).length - 1;
      state.currentIndex = newIndex;
    }
  }
})

export const getTodoFilterByIndex = (index: number) => IOC.findByToken(DITodoFilters)[index];

export const {reducer: sortTodoReducer, actions: {nextSorter, prevSorter} } = sortTodoSlice;
