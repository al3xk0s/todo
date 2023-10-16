import { Dispatch, Reducer, createContext, useContext, useReducer, useRef, useState } from "react";
import { MyModal } from "./Modal";

export interface ModalProps {
  children: React.ReactNode,
  contentSize?: {
    height?: string | number,
    width?: string | number,
  }
}

interface ModalState {
  visible: boolean,
  props?: ModalProps,
}

const useModalState = () => {
  const [state, setState] = useState<ModalState>({visible: true});

  return {
    modalOpen: state.visible,
    props: state.props,
    openModal: (props: ModalProps) => setState({visible: true, props}),
    closeModal: () => setState({visible: false})
  }
}

const ModalContext = createContext<ReturnType<typeof useModalState> | undefined>(undefined);

interface ModalProviderProps {
  children?: React.ReactNode,
}

export const ModalProvider = ({children}: ModalProviderProps) => {
  const modalState = useModalState();

  return (
    <ModalContext.Provider value={modalState}>
      <MyModal />
      {children}
    </ModalContext.Provider>
  );
}

export const useModal = () => useContext(ModalContext)!;
