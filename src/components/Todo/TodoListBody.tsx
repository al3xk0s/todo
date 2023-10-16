import { TodoActions, useTodo } from "../../hooks/useTodo";
import { ITodo } from "../../models/Todo";
import { AddTodo } from "./AddTodo";
import { Todo } from "./Todo";
import { TodoWrapper } from "./TodoWrapper";

interface TodoListBodyProps {
  readonly items: ITodo[];
  readonly actions: TodoActions,
}

export const TodoListBody = ({items, actions}: TodoListBodyProps) => {
  const {update, remove, add} = actions;

  const mapElement = (e: ITodo) => {
    return (
      <TodoWrapper key={e.id}>
        <Todo todo={e} update={(value) => update(e.id, value)} remove={() => remove(e.id)}/>
      </TodoWrapper>
    )
  }

  return (
    <div className="d-flex flex-column justify-content-start h-100">
      {items.map(mapElement)}
      <TodoWrapper key={'add-todo'}>
        <AddTodo addTodo={add} />
      </TodoWrapper>
    </div>
  );
}
