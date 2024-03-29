import clsx from "clsx";
import { useModal } from "./useModal";
import { elementContainsAnyClass } from "../../handlers/TargetValidators";
import { useAppDispatch, useAppSelector } from "../../../app/hooks";
import { modalStateSelector } from "./modalSelectors";

export const MyModal = () => {
  const {modalOpen, props} = useAppSelector(modalStateSelector);
  const {closeModal} = useModal();

  if(props == null || !modalOpen) return null;

  const {contentSize, children} = props!;

  let {height, width} = contentSize ?? {};
  const defaultContentSize = '75%';
  height = height ?? defaultContentSize;
  width = width ?? defaultContentSize;

  const canvasClass = 'modal-canvas';

  const onClickToModalCanvas = (ev: React.MouseEvent<HTMLDivElement, MouseEvent>) => {
    if(!elementContainsAnyClass(ev.target, canvasClass)) return;
    closeModal();
  }

  return (
    <div className={clsx(canvasClass, 'd-flex')} onClick={onClickToModalCanvas} style={{zIndex: 10000, position: 'fixed', backgroundColor: 'rgba(128, 128, 128, 0.5)', height: '100vh', width: '100vw'}}>
      <div className="m-auto" style={{backgroundColor: 'white', height: height, width: width, boxShadow: 'box-shadow: 12px 12px 2px 1px rgba(0, 0, 255, .2)'}}>
        {children}
      </div>
    </div>
  );
}

interface MyModalContentProps {
  children: React.ReactNode,
  title: string;
}

export const MyModalContent = ({title, children}: MyModalContentProps) => {
  return (
    <div className="d-flex flex-column align-items-start p-3 h-100 w-100">
      <h3 className="title">{title}</h3>
      <div>
        {children}
      </div>
    </div>
  );
}
