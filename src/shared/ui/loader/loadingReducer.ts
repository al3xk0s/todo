import { createSlice } from "@reduxjs/toolkit";

export interface LoadingState {
  isLoading: boolean,
}

const initialState : LoadingState = { isLoading: false }

const loaderSlice = createSlice({
  name: 'loader',
  initialState,
  reducers: {
    enableLoading: (state) => {
      state.isLoading = true;
    },
    disableLoading: (state) => {
      state.isLoading = false;
    }
  }
});

export const {reducer: loadingRedicer, actions: {enableLoading, disableLoading} } = loaderSlice;