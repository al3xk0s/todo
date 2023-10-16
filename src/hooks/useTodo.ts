import { useState } from "react";
import { ITodoRepository } from "../services/TodoRepository";
import { CreateTodoDTO, ITodo, UpdateTodoDTO } from "../models/Todo";

const sortTodos = (todos: ITodo[]) => {
  const newTodos = todos.sort((f, l) => f.timestamp - l.timestamp);

  return [
    ...newTodos.filter((t) => !t.isDone),
    ...newTodos.filter((t) => t.isDone),
  ]
}

export const useTodo = (repo: ITodoRepository) => {
  const [todos, setTodos] = useState<ITodo[]>([]);
  const [isLoading, setLoading] = useState(false);

  const withLoading = (callback: () => Promise<void>) => {
    return async () => {
      setLoading(true);
      await callback();
      setLoading(false);
    }
  }

  const localFetch = async () => setTodos(sortTodos(await repo.getAll()));

  const withLocalFetch = (callback: () => Promise<void>) => {
    const executor = withLoading(async () => {
      await callback();
      await localFetch();
    });

    executor();
  }

  const actions = {
    fetchAll: withLoading(localFetch),
    add: (createDTO: CreateTodoDTO) => withLocalFetch(() => repo.createTodo(createDTO)),
    update: (id: string, updateDTO: UpdateTodoDTO) => withLocalFetch(() => repo.updateTodo(id, updateDTO)),
    remove: (id: string) => withLocalFetch(() => repo.removeTodo(id)),
  };

  return {isLoading, todos, actions};
};

export type TodoActions = ReturnType<typeof useTodo>['actions'];