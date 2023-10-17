import { configureStore } from "@reduxjs/toolkit";
import { todosReducer } from "../features/todo/redux/reducers/todoReducer";
import { modalReducer, openModal } from "../shared/ui/modal/modalReducer";

const reducer = {
  todos: todosReducer,
  modal: modalReducer,
};

export const store = configureStore({
  reducer,
  middleware: (getDefaultMiddleware) => {
    return getDefaultMiddleware({
      serializableCheck: {
        ignoredActions: [openModal.type],
        ignoredPaths: ['modal.props'],
      },
    })
  },
});

export type RootState = ReturnType<typeof store.getState>;
export type AppDispatch = typeof store.dispatch;
export type RootReducerType = typeof reducer;
export type AsyncThunkConfigType = { rejectValue: string, state: RootState };
