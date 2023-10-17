import { useEffect } from "react";
import { TodoListBody } from "./TodoListBody";
import { Loader } from "../../../shared/ui/loader/Loader";
import { useAppDispatch, useAppSelector } from "../../../app/hooks";
import { loadingTodoSelector } from "../redux/selectors/todoSelectors";
import { fetchTodos } from "../redux/reducers/todoReducer";

export const TodoList = () => {
  const dispatch = useAppDispatch();
  const isLoading = useAppSelector(loadingTodoSelector);

  useEffect(() => {
    dispatch(fetchTodos());
  }, [dispatch]);

  return (
    <div className="h-100 w-50 m-auto">{ isLoading ?
      <Loader /> :
      <TodoListBody />
    } </div>
  );
}
