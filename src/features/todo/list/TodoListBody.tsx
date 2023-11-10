import { useCallback } from "react";
import { ITodo, UpdateTodoDTO } from "../../../entities/todo/models/Todo";
import { AnimatedTodo, Todo } from "../../../entities/todo/ui/Todo";
import { TodoWrapper } from "../../../entities/todo/ui/TodoWrapper";
import { CreateTodo } from "../create/ui/CreateTodo";
import { useAppDispatch, useAppSelector } from "../../../app/hooks";
import { filtredTodosSelector } from "../redux/selectors/todoSelectors";
import { updateTodo, removeTodo } from "../redux/reducers/todoReducer";


export const TodoListBody = () => {
  const dispatch = useAppDispatch();
  
  const mapElement = (e: ITodo) => {
    const onUpdate = (v: UpdateTodoDTO) => dispatch(updateTodo({id: e.id, dto: v}));
    const onRemove = () => dispatch(removeTodo({id: e.id}));

    return (
      <AnimatedTodo key={e.id} todoID={e.id}>
        <TodoWrapper>
          <Todo todo={e} onUpdate={onUpdate} onRemove={onRemove}/>
        </TodoWrapper>
      </AnimatedTodo>
    )
  }

  const todos = useAppSelector(filtredTodosSelector);

  return (
    <div className="d-flex flex-column justify-content-start h-100">
      {todos.map(mapElement)}
      <TodoWrapper key={'add-todo'}>
        <CreateTodo />
      </TodoWrapper>
    </div>
  );
}
