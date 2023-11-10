import { ChangeEvent, FormEvent, useEffect, useMemo, useRef } from "react";
import { useRefInput, useStateInput } from "../../../../shared/hooks/useInput";
import { useAppDispatch, useAppSelector } from "../../../../app/hooks";
import { createTodo } from "../../redux/reducers/todoReducer";
import { IDebounceController, createDebounce } from "../../../../shared/utils/debounce";
import { updateCreateTodoTitle } from "../../redux/reducers/createTodoTitleReducer";
import { savedCreateTodoTitleSelector } from "../../redux/selectors/todoSelectors";
import { useDebounce } from "../../../../shared/hooks/useDebounce";

export const CreateTodo = () => {
  const savedTitle = useAppSelector(savedCreateTodoTitleSelector);

  const {value, setValue, bind} = useStateInput(savedTitle);
  const deboucedValue = useDebounce(value, 500);

  const dispatch = useAppDispatch();

  useEffect(() => {
    return () => { dispatch(updateCreateTodoTitle(value)) };
  }, []);


  useEffect(() => {
    dispatch(updateCreateTodoTitle(deboucedValue));
  }, [deboucedValue]);

  const onSubmit = (ev: FormEvent<HTMLFormElement>) => {
    ev.preventDefault();

    const trimedValue = value.trim();
    if(trimedValue == null || trimedValue.length === 0) return;

    dispatch(createTodo({dto: {title: trimedValue}}));
    setValue('');
  };

  return (
    <form className="w-100" onSubmit={onSubmit}>
      <input placeholder="Начните вводить задачу..." autoFocus {...bind} type="text" className=" w-100 p-2 form-control"/>
    </form>
  );
}
