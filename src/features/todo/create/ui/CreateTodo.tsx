import { FormEvent, useRef } from "react";
import { useRefInput } from "../../../../shared/hooks/useInput";
import { useAppDispatch } from "../../../../app/hooks";
import { createTodo } from "../../redux/reducers/todoReducer";

export const CreateTodo = () => {
  const {ref, bind} = useRefInput<HTMLInputElement>();
  const dispatch = useAppDispatch();

  const onSubmit = (ev: FormEvent<HTMLFormElement>) => {
    ev.preventDefault();

    const trimedValue = ref.current?.value.trim();
    if(trimedValue == null || trimedValue.length === 0) return;

    dispatch(createTodo({dto: {title: trimedValue}}));
    if(ref.current) ref.current.value = '';
  };

  return (
    <form className="w-100" onSubmit={onSubmit}>
      <input placeholder="Начните вводить задачу..." autoFocus {...bind} type="text" className=" w-100 p-2 form-control"/>
    </form>
  );
}
