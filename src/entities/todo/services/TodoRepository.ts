import { DINamedEntity } from "../../../shared/services/ServiceLocator";
import { ITodo, CreateTodoDTO, UpdateTodoDTO } from "../models/Todo";

export interface ITodoRepository {
  getAll() : Promise<ITodo[]>;
  createTodo(createDTO: CreateTodoDTO) : Promise<ITodo>;
  updateTodo(id: string, updateDTO: UpdateTodoDTO) : Promise<ITodo>;
  removeTodo(id: string) : Promise<void>;
}

export class TodoRepository implements ITodoRepository {
  private readonly _path = 'http://localhost:18080';

  async getAll(): Promise<ITodo[]> {
    const res = await fetch(`${this._path}/todo`, {method: 'GET'});
    return await res.json();
  }

  async createTodo(createDTO: CreateTodoDTO): Promise<ITodo> {
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

  async updateTodo(id: string, updateDTO: UpdateTodoDTO): Promise<ITodo> {
    const res = await fetch(
      `${this._path}/todo/${id}`, {
      method: 'POST',
      headers: {
        'Content-type': 'application/json',
      },
      body: JSON.stringify(updateDTO),
    });

    return await res.json();
  }

  async removeTodo(id: string): Promise<void> {
    const res = await fetch(
      `${this._path}/todo/${id}`, {
      method: 'DELETE',      
    });
  }
}

export const DITodoRepository : DINamedEntity<ITodoRepository> = { token: 'DITodoRepository' };