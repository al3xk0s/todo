import { PayloadAction, createSlice } from "@reduxjs/toolkit";
import { ModalProps } from "./useModal";

export interface ModalState {
  isOpen: boolean,
  props?: ModalProps,
}

const initialState : ModalState = {
  isOpen: false,
}

const modalSlice = createSlice({
  name: 'modal',
  initialState,
  reducers: {
    openModal: (state, actions: PayloadAction<ModalProps>) => {
      state.isOpen = true;
      state.props = actions.payload;
    },
    closeModal: (state) => {
      state.isOpen = false;
      state.props = undefined;
    }
  }
});

export const {reducer: modalReducer, actions: {openModal, closeModal}} = modalSlice;