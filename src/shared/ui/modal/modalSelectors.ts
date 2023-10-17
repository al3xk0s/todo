import { createSelector } from "@reduxjs/toolkit";
import { RootState } from "../../../app/store";

export const modalStateSelector = createSelector(
  (s: RootState) => s.modal,
  ({isOpen, props}) => ({ modalOpen: isOpen, props })
);