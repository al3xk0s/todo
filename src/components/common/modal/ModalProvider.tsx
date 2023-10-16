import { Dispatch, Reducer, createContext, useContext, useReducer, useRef, useState } from "react";
import { MyModal } from "./Modal";

export interface ModalProps {
  children: React.ReactNode,
  contentSize?: {
    height?: string | number,
    width?: string | number,
  }
}

interface ModalAction {
  type: 'show' | 'hide',
  props?: ModalProps,
}

interface ModalState {
  visible: boolean;
  props?: ModalProps,
}

const modalReducer = (state: ModalState, action: ModalAction) : ModalState => {
  if(action.type === 'show') return { ...state, visible: true, props: action.props }
  if(action.type === 'hide') return { ...state, visible: false, props: undefined };

  return state;
}

const getModalState = (state: ModalState, dispatch: Dispatch<ModalAction>) => {
  return {
    modalOpen: state.visible,
    props: state.props,
    openModal: (props: ModalProps) => dispatch({type: 'show', props}),
    closeModal: () => dispatch({type: 'hide'})
  }
}

const ModalContext = createContext<ReturnType<typeof getModalState> | undefined>(undefined);

interface ModalProviderProps {
  children?: React.ReactNode,
}

export const ModalProvider = ({children}: ModalProviderProps) => {
  const [state, dispatch] = useReducer(modalReducer, {visible: false});
  const modalState = getModalState(state, dispatch);

  return (
    <ModalContext.Provider value={modalState}>
      <MyModal />
      {children}
    </ModalContext.Provider>
  );
}

export const useModal = () => useContext(ModalContext)!;
