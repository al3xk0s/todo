import React, { ReactNode, useState } from "react";
import { ITodo, UpdateTodoDTO } from "../../../entities/todo/models/Todo";
import clsx from "clsx";
import { useModal } from "../../../shared/ui/modal/useModal";
import { elementContainsAnyClass } from "../../../shared/handlers/TargetValidators";
import { IHasValue, InputStateBind, useStateInput } from "../../../shared/hooks/useInput";

interface TodoUpdateModalContentProps {
  todo: ITodo;
  update: (updateDTO: UpdateTodoDTO) => void;
}

enum EditMode {
  title,
  decs,
  none
}

export const UpdateTodoModal = ({todo, update}: TodoUpdateModalContentProps) => {
  const {closeModal} = useModal();

  const [editMode, setEditMode] = useState(EditMode.none);

  const {value: title, bind: titleBind} = useStateInput(todo.title);
  const {value: description, bind: descriptionBind} = useStateInput<IHasValue>(todo.description ?? '');

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
    if(!elementContainsAnyClass(ev.target, targetButtonDiv, targetContentClass)) return;

    setEditMode(EditMode.none);
  }

  const titleElement = getTitleElement(editMode, titleBind, setEditMode);
  const descriptionElement = getDescriptionElement(editMode, descriptionBind, setEditMode);

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
  inputBind: InputStateBind,
}

const InputComponent = ({isInput, inputBind, children, setIsInput, rowsCount}: InputComponentProps) => {
  const supressFormEvent = (ev: React.FormEvent<HTMLFormElement>) => {
    ev.preventDefault();
    setIsInput(false);
  }

  return (
    <div onClick={() => setIsInput(true)} className="h-100 w-100 border-dark-subtle">
      { isInput ?
          <form onSubmit={supressFormEvent} className="h-100 w-100">
             { rowsCount <= 1 ?
                <input className="form-control" {...inputBind} /> :
                <textarea className="form-control h-100 w-100" {...inputBind} />
              }
          </form> :
          children
      }
    </div>
  )     
}

function getDescriptionElement(editMode: EditMode, descriptionStateBind: InputStateBind<IHasValue>, setEditMode: React.Dispatch<React.SetStateAction<EditMode>>) {
  const {value: description} = descriptionStateBind;

  return <InputComponent
    rowsCount={3}
    isInput={editMode === EditMode.decs}
    inputBind={descriptionStateBind}
    setIsInput={(value) => value ? setEditMode(EditMode.decs) : setEditMode(EditMode.none)}
  >
    <h5 className="subtitle text-wrap h-100 text-left" style={{ float: 'left', color: description.length === 0 ? 'grey' : undefined }}>{description.length === 0 ? 'Нет описания. Добавим?' : description}</h5>
  </InputComponent>;
}

function getTitleElement(editMode: EditMode, titleBind: InputStateBind<HTMLInputElement>, setEditMode: React.Dispatch<React.SetStateAction<EditMode>>) {
  return <InputComponent
    rowsCount={1}
    isInput={editMode === EditMode.title}
    inputBind={titleBind as InputStateBind}
    setIsInput={(value) => value ? setEditMode(EditMode.title) : setEditMode(EditMode.none)}
  >
    <h3 className="title text-wrap h-100 text-left " style={{ float: 'left' }}>{titleBind.value}</h3>
  </InputComponent>;
}

