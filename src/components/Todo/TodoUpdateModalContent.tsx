import React, { ReactNode, useState } from "react";
import { ITodo, UpdateTodoDTO } from "../../models/Todo";
import clsx from "clsx";
import { useModal } from "../common/modal/ModalProvider";

interface TodoUpdateModalContentProps {
  todo: ITodo;
  update: (updateDTO: UpdateTodoDTO) => void;
}

enum EditMode {
  title,
  decs,
  none
}

export const TodoUpdateModalContent = ({todo, update}: TodoUpdateModalContentProps) => {
  const {closeModal} = useModal();

  const [editMode, setEditMode] = useState(EditMode.none);

  const [title, setTitle] = useState(todo.title);
  const [description, setDescription] = useState(todo.description ?? '');

  const targetContentClass = 'todo-modal-content';
  const targetButtonDiv = 'todo-modal-btn-div';

  const save = () => {
    setEditMode(EditMode.none);
    const newTitle = title.trim();
    const newDescription = description.trim();

    if(newTitle.length === 0) return;
    update({title: newTitle, description: newDescription.length > 0 ? newDescription : undefined });
    closeModal();
  }

  const cancel = () => closeModal();

  const onClickToContentArea = (ev: React.MouseEvent<HTMLDivElement, MouseEvent>) => {
    const classList = (ev.target as HTMLDivElement).classList;
    const isTargetElement = (classList?.contains(targetButtonDiv) ?? false) || 
    (classList?.contains(targetContentClass) ?? false)

    if(!isTargetElement) return;

    setEditMode(EditMode.none);
  }

  const titleElement = getTitleElement(editMode, title, setTitle, setEditMode);
  const descriptionElement = getDescriptionElement(editMode, description, setDescription, setEditMode);

  return (
    <div onClick={onClickToContentArea} className={clsx('d-flex flex-column align-items-start p-3 h-100 w-100', targetContentClass)}>
      <div className="w-100" style={{minHeight: '10%'}}>{titleElement}</div>      
      <div style={{ borderTop: '3px solid #000000', height: '10px' }}></div>
      <div className="w-100 h-100 flex-wrap mb-3" >{descriptionElement}</div>
      <div className={clsx('d-flex justify-content-between align-self-end w-100', targetButtonDiv)} style={{height: '8%'}}>
        <button onClick={cancel} className="btn btn-primary">Отменить</button>
        {
          title.trim().length > 0 ?
            <button onClick={save} className="btn btn-success">Сохранить</button> :
            <div></div>
        }
      </div>      
    </div>
  );
}

interface InputComponentProps {
  children: ReactNode,
  isInput: boolean,
  rowsCount: number,
  setIsInput: (value: boolean) => void,
  text: string,
  setText: (t: string) => void,
}

const InputComponent = ({isInput, text, setText, children, setIsInput, rowsCount}: InputComponentProps) => {
  const supressFormEvent = (ev: React.FormEvent<HTMLFormElement>) => {
    ev.preventDefault();
    setIsInput(false);
  }

  return (
    <div onClick={() => setIsInput(true)} className="h-100 w-100 border-dark-subtle">
      { isInput ?
          <form onSubmit={supressFormEvent} className="h-100 w-100">
             { rowsCount <= 1 ?
                <input className="form-control" value={text} onChange={(ev) => setText(ev.target.value)} /> :
                <textarea className="form-control h-100 w-100" value={text} onChange={(ev) => setText(ev.target.value)} />
              }
          </form> :
          children
      }
    </div>
  )     
}

function getDescriptionElement(editMode: EditMode, description: string, setDescription: React.Dispatch<React.SetStateAction<string>>, setEditMode: React.Dispatch<React.SetStateAction<EditMode>>) {
  return <InputComponent
    rowsCount={3}
    isInput={editMode === EditMode.decs}
    text={description}
    setText={setDescription}
    setIsInput={(value) => value ? setEditMode(EditMode.decs) : setEditMode(EditMode.none)}
  >
    <h5 className="subtitle text-wrap h-100 text-left" style={{ float: 'left', color: description.length === 0 ? 'grey' : undefined }}>{description.length === 0 ? 'Нет описания. Добавим?' : description}</h5>
  </InputComponent>;
}

function getTitleElement(editMode: EditMode, title: string, setTitle: React.Dispatch<React.SetStateAction<string>>, setEditMode: React.Dispatch<React.SetStateAction<EditMode>>) {
  return <InputComponent
    rowsCount={1}
    isInput={editMode === EditMode.title}
    text={title}
    setText={setTitle}
    setIsInput={(value) => value ? setEditMode(EditMode.title) : setEditMode(EditMode.none)}
  >
    <h3 className="title text-wrap h-100 text-left " style={{ float: 'left' }}>{title}</h3>
  </InputComponent>;
}

