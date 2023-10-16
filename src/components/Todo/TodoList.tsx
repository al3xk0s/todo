import { useEffect } from "react";
import { useTodo } from "../../hooks/useTodo";
import { ITodoRepository } from "../../services/TodoRepository";
import { Loader } from "../common/Loader";
import { TodoListBody } from "./TodoListBody";

export interface TodoListProps {
  repository: ITodoRepository
}

export const TodoList = ({repository}: TodoListProps) => {
  const {isLoading, todos, actions} = useTodo(repository);

  useEffect(() => {
    actions.fetchAll();
  }, [actions]);

  return (
    <div className="h-100 w-50 m-auto">{ isLoading ?
      <Loader /> :
      <TodoListBody items={todos} actions={actions}/>
    } </div>
  );
}
