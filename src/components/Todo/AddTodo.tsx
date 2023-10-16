import { FormEvent, useRef } from "react";
import { TodoActions } from "../../hooks/useTodo";
import { useRefInput, useStateInput } from "../../hooks/common/useInput";

interface AddTodoProps {
  addTodo: TodoActions['add'];
}

export const AddTodo = ({addTodo}: AddTodoProps) => {
  const {ref, bind} = useRefInput<HTMLInputElement>();

  const onSubmit = (ev: FormEvent<HTMLFormElement>) => {
    ev.preventDefault();

    const trimedValue = ref.current?.value.trim();
    if(trimedValue == null || trimedValue.length === 0) return;

    addTodo({title: trimedValue});
  };

  return (
    <form className="w-100" onSubmit={onSubmit}>
      <input placeholder="Начните вводить задачу..." autoFocus {...bind} type="text" className=" w-100 p-2 form-control"/>
    </form>
  );
}
