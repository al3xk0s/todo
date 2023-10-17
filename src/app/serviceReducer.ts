import { createReducer } from "@reduxjs/toolkit";
import { ITodoRepository, TodoRepository } from "../entities/todo/services/TodoRepository";

export const serviceReducer = createReducer({
  todo: {
    repo: new TodoRepository() as ITodoRepository,
  }
}, b => {});
