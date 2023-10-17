import { NamedEntity } from "../../../shared/services/ServiceLocator";
import { ITodo } from "../models/Todo";

export type TodoFilter = (todos: ITodo[]) => ITodo[];

export const timestampTodoSorter : TodoFilter = (todos) => todos.filter(_ => true).sort((f, l) => f.timestamp - l.timestamp);
export const completedOnlyTodoFilter : TodoFilter = (todos) => todos.filter(t => t.isDone);
export const uncompletedOnlyTodoFilter : TodoFilter = (todos) => todos.filter(t => !t.isDone);

export const timestampCompletedFirstTodoFilter : TodoFilter = (todos) => {
  const newTodos = timestampTodoSorter(todos);

  return [
    ...uncompletedOnlyTodoFilter(newTodos),
    ...completedOnlyTodoFilter(newTodos),
  ]
}

export enum TodoFilterName {
  all,
  uncompleted,
  completed,
}

export interface NamedTodoFilter {
  readonly name: TodoFilterName,
  readonly exec: TodoFilter,
}

export const DITodoFilters : NamedEntity<NamedTodoFilter[]> = {token: 'DITodoFilters'};
