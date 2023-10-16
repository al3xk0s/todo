import { CreateTodoDTO, ITodo, UpdateTodoDTO } from "../models/Todo";
import { v4 as uuid } from 'uuid';

export interface ITodoRepository {
  getAll() : Promise<ITodo[]>;
  createTodo(createDTO: CreateTodoDTO) : Promise<void>;
  updateTodo(id: string, updateDTO: UpdateTodoDTO) : Promise<void>;
  removeTodo(id: string) : Promise<void>;
}

export class TodoRepository implements ITodoRepository {
  private readonly _path = 'http://localhost:18080';

  async getAll(): Promise<ITodo[]> {
    const res = await fetch(`${this._path}/todo`, {method: 'GET'});
    return await res.json();
  }

  async createTodo(createDTO: CreateTodoDTO): Promise<void> {
    const res = await fetch(
      `${this._path}/todo`, {
      method: 'POST',
      headers: {
        'Content-type': 'application/json',
      },
      body: JSON.stringify(createDTO),
    });
    return await res.json();
  }

  async updateTodo(id: string, updateDTO: UpdateTodoDTO): Promise<void> {
    const res = await fetch(
      `${this._path}/todo/${id}`, {
      method: 'POST',
      headers: {
        'Content-type': 'application/json',
      },
      body: JSON.stringify(updateDTO),
    });
  }

  async removeTodo(id: string): Promise<void> {
    const res = await fetch(
      `${this._path}/todo/${id}`, {
      method: 'DELETE',      
    });
  }
}
