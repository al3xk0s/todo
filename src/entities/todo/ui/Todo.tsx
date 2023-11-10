import { ReactNode, useState } from "react";
import { ITodo, UpdateTodoDTO } from "../models/Todo";
import EditIcon from '@mui/icons-material/Edit';
import DeleteIcon from '@mui/icons-material/Delete';
import clsx from "clsx";
import { UpdateTodoModal } from "../../../features/todo/update/UpdateTodoModal";
import { useModal } from "../../../shared/ui/modal/useModal";
import { AnimatePresence, motion } from "framer-motion";

export interface TodoProps {
  readonly todo: ITodo;
  readonly onUpdate: (updateDTO: UpdateTodoDTO) => void;
  readonly onRemove: () => void;
}

export const Todo = ({todo, onUpdate: update, onRemove: remove}: TodoProps) => {
  const {openModal} = useModal();
  const onClick = () => update({isDone: !todo.isDone});
  
  const titleElement = <p className="card-title mb-0 text-wrap">{todo.title}</p>;
  const buttonSize = 35;
  const iconSize = buttonSize * 0.55;

  const openUpdateTodoModal = () => {
    openModal({
      children: <UpdateTodoModal todo={todo} update={update}/>
    });
  }

  return (
    <div id={todo.id} className="card d-flex flex-row align-items-center justify-content-between p-2">
      <div className="flex-wrap d-flex justify-content-start" style={{width: '90%'}} onClick={onClick}>{todo.isDone ? <del>{titleElement}</del> : titleElement }</div>      
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

export const AnimatedTodo = ({todoID, children}: { todoID: string, children: ReactNode }) => {
  return (
    <AnimatePresence initial={false} mode="popLayout">
      <motion.div
        key={todoID}
        animate={{
          height: 'auto',
          opacity: 1,
        }}
        exit={{
          height: 0,
        }}
      >
        {children}
      </motion.div>
    </AnimatePresence>
  )
}
