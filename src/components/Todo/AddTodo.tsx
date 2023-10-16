import { FormEvent, useRef } from "react";
import { TodoActions } from "../../hooks/useTodo";

interface AddTodoProps {
  addTodo: TodoActions['add'];
}

export const AddTodo = ({addTodo}: AddTodoProps) => {
  const inputRef = useRef<HTMLInputElement>(null);

  const onSubmit = (ev: FormEvent<HTMLFormElement>) => {
    ev.preventDefault();

    const value = inputRef?.current?.value.trim();
    if(value == null || value.length === 0) return;

    addTodo({title: value});
  };

  return (
    <form className="w-100" onSubmit={onSubmit}>
      <input placeholder="Начните вводить задачу..." autoFocus ref={inputRef} type="text" className=" w-100 p-2 form-control"/>
    </form>
  );
}
