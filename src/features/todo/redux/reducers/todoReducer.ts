import { AnyAction, PayloadAction, combineReducers, createAsyncThunk, createReducer, createSlice } from "@reduxjs/toolkit";
import { sortTodoReducer } from "./todoFilterReducer";
import { AsyncThunkConfigType } from "../../../../app/store";
import { ITodo, UpdateTodoDTO, CreateTodoDTO } from "../../../../entities/todo/models/Todo";
import { TodoRepository, ITodoRepository, DITodoRepository } from "../../../../entities/todo/services/TodoRepository";
import { IAsyncState } from "../../../../shared/models/state";
import { ObjectMap } from "../../../../shared/types";
import { IOC } from "../../../../shared/services/ServiceLocator";
import { createTodoTitleReducer, updateCreateTodoTitle } from "./createTodoTitleReducer";

export interface TodoState extends IAsyncState<ObjectMap<ITodo>> {}

const initialState : TodoState = {
  isComplete: true,
}

export const toggleTodo = createAsyncThunk<
  ITodo,
  { id: string, dto: UpdateTodoDTO },
  AsyncThunkConfigType
>(
  'todos/toggleTodo',
  async ({id, dto}, thunkAPI) => {
    try {
      const repo = IOC.findByToken<ITodoRepository>(DITodoRepository);
      return await repo.updateTodo(id, dto);
    } catch(e) {
      return thunkAPI.rejectWithValue((e as Error).message);
    }
  }
);

export const updateTodo = createAsyncThunk<
  ITodo,
  {id: string, dto: UpdateTodoDTO},
  AsyncThunkConfigType
>(
  'todos/updateTodo',
  async ({id, dto}, thunkAPI) => {
    try {
      const repo = IOC.findByToken<ITodoRepository>(DITodoRepository);
      return await repo.updateTodo(id, dto);
    } catch(e) {
      return thunkAPI.rejectWithValue((e as Error).message);
    }
  }
)

export const removeTodo = createAsyncThunk<
  string,
  {id: string},
  AsyncThunkConfigType
>(
  'todos/removeTodo',
  async ({id}: {id: string}, thunkAPI) => {
    try {
      const repo = IOC.findByToken<ITodoRepository>(DITodoRepository);
      await repo.removeTodo(id);
      return id;
    } catch(e) {
      return thunkAPI.rejectWithValue((e as Error).message);
    }
  }
)

export const createTodo = createAsyncThunk<
  ITodo,
  {dto: CreateTodoDTO},
  AsyncThunkConfigType
>(
  'todos/createTodo',
  async ({dto}, thunkAPI) => {
    try {
      const repo = IOC.findByToken<ITodoRepository>(DITodoRepository);
      return await repo.createTodo(dto);
    } catch(e) {
      return thunkAPI.rejectWithValue((e as Error).message);
    }
  }
)

export const fetchTodos = createAsyncThunk<
  ITodo[],
  void,
  AsyncThunkConfigType
>(
  'todos/fetchTodos',
  async (_, thunkAPI) => {
    try {
      const repo = IOC.findByToken<ITodoRepository>(DITodoRepository);
      return await repo.getAll();
    } catch (e) {
      return thunkAPI.rejectWithValue((e as Error).message);
    }
  }
)

const onTodoModify = (state: any, action: { payload: ITodo }) => {
  state.data = state.data ?? {};
  state.data[action.payload.id] = action.payload;
  state.error = undefined;
}

const todoSlice = createSlice({
  name: 'todos',
  initialState,
  reducers: {

  },
  extraReducers: (builder) => {
    builder.
      addCase(fetchTodos.fulfilled, (state, action) => {
        const map : ObjectMap<ITodo> = {};
        action.payload.forEach((e) => map[e.id] = e);

        state.data = map;
        state.isComplete = true;
        state.error = undefined;
      })
      .addCase(fetchTodos.pending, (state) => {
        state.isComplete = false;
        state.error = undefined;
      })
      .addCase(createTodo.fulfilled, onTodoModify)
      .addCase(updateTodo.fulfilled, onTodoModify)
      .addCase(toggleTodo.fulfilled, onTodoModify)
      .addCase(removeTodo.fulfilled, (state, action) => {
        state.data = state.data ?? {};
        delete state.data[action.payload]
        state.error = undefined;
      })
      .addMatcher((a: AnyAction) => (a.type as string).endsWith('rejected'), (state, action: PayloadAction<string>) => {
        state.isComplete = true;
        state.error = action.payload;
      })
  }
});

export const todosReducer = combineReducers({
  state: todoSlice.reducer,
  filter: sortTodoReducer,
  createTodoTitle: createTodoTitleReducer,
});
