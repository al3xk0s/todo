import { PayloadAction, createSlice } from "@reduxjs/toolkit";

export interface CreateTodoTitleState {
    value: string;
}

const createTodoTitleSlice = createSlice({
    name: 'todos/create/title',
    initialState: { value: '' },
    reducers: {
        updateCreateTodoTitle: (state, actions: PayloadAction<string>) => {
            console.log('save title')
            if(state.value == actions.payload) return;
            state.value = actions.payload;
        },        
    }
});

export const { reducer: createTodoTitleReducer, actions: { updateCreateTodoTitle } } = createTodoTitleSlice;