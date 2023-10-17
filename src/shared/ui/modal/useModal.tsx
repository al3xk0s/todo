import { useMemo } from "react";
import { useAppDispatch, useAppSelector } from "../../../app/hooks";
import { closeModal, openModal } from "./modalReducer";
import { modalStateSelector } from "./modalSelectors";

export interface ModalProps {
  children: React.ReactNode,
  contentSize?: {
    height?: string | number,
    width?: string | number,
  }
}

export const useModal = () => {
  const dispatch = useAppDispatch();

  return useMemo(() => ({
    openModal: (props: ModalProps) => dispatch(openModal(props)),
    closeModal: () => dispatch(closeModal())
  }), [dispatch])
};
