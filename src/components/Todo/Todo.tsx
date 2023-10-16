import { ReactNode, useState } from "react";
import { ITodo, UpdateTodoDTO } from "../../models/Todo";
import EditIcon from '@mui/icons-material/Edit';
import DeleteIcon from '@mui/icons-material/Delete';
import clsx from "clsx";
import { TodoUpdateModalContent } from "./TodoUpdateModalContent";
import { useModal } from "../common/modal/ModalProvider";

export interface TodoProps {
  readonly todo: ITodo;
  readonly update: (updateDTO: UpdateTodoDTO) => void;
  readonly remove: () => void;
}

export const Todo = ({todo, update, remove}: TodoProps) => {
  const [isDoneState, setDoneState] = useState(todo.isDone);

  const onClick = () => {
    setDoneState((prev) => {
      const newValue = !prev;
      update({isDone: newValue});
      return newValue;
    })
  };
  
  const titleElement = <p className="card-title mb-0 text-wrap">{todo.title}</p>;
  const buttonSize = 35;
  const iconSize = buttonSize * 0.55;

  const {openModal} = useModal();
  const openUpdateTodoModal = () => {
    openModal({
      children: <TodoUpdateModalContent todo={todo} update={update}/>
    });
  }

  return (
    <div id={todo.id} className="card d-flex flex-row align-items-center justify-content-between p-2">
      <div className="flex-wrap d-flex justify-content-start" style={{width: '90%'}} onClick={onClick}>{isDoneState ? <del>{titleElement}</del> : titleElement }</div>      
      <div className="d-flex justify-content-end">
        <TodoButton size={buttonSize} isPrimary={true} onClick={openUpdateTodoModal}>
          <EditIcon style={{height: iconSize, width: iconSize}}/>
        </TodoButton>
        <TodoButton size={buttonSize} isPrimary={false} onClick={remove}>
          <DeleteIcon style={{height: iconSize, width: iconSize}}/>
        </TodoButton>
      </div> 
    </div>
  );
};

interface TodoButtonProps {
  readonly children: ReactNode,
  readonly onClick: () => void,
  readonly isPrimary: boolean,
  readonly size: string | number,
}

const TodoButton = ({onClick, children, size, isPrimary}: TodoButtonProps) => {
  const className = clsx("btn", isPrimary ? 'btn-primary' : 'btn-danger', 'rounded-circle', 'mx-1', 'd-flex justify-content-center align-items-center');

  return (
    <button className={className} onClick={onClick} style={{width: size, height: size}}>{children}</button>
  );
}
