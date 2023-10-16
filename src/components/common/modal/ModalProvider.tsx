import { createContext, useContext, useRef, useState } from "react";
import { MyModal } from "./Modal";

export interface ModalProps {
  children: React.ReactNode,
  contentSize?: {
    height?: string | number,
    width?: string | number,
  }
}

const useModalState = (initial: boolean | undefined = undefined) => {
  const [modalOpen, setOpened] = useState(initial);
  const propsRef = useRef<ModalProps | undefined>(undefined);

  return {
    modalOpen,
    openModal: (props: ModalProps) => {
      propsRef.current = props;
      setOpened(true);
    },
    closeModal: () => {
      propsRef.current = undefined;
      setOpened(false);
    },
    propsRef,
  }
}

export type ModalState = ReturnType<typeof useModalState>;

const ModalContext = createContext<ModalState | undefined>(undefined);

interface ModalProviderProps {
  children?: React.ReactNode,
  initialValue?: boolean,
}

export const ModalProvider = ({children, initialValue}: ModalProviderProps) => {
  const state = useModalState(initialValue ?? false);

  return (
    <ModalContext.Provider value={state}>
      <MyModal />
      {children}
    </ModalContext.Provider>
  );
}

export const useModal = () => useContext(ModalContext)!;
