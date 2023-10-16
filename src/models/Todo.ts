export interface ITodo {
  readonly id: string;
  readonly title: string;
  readonly description?: string;
  readonly isDone: boolean;
  readonly timestamp: number;
}

export type UpdateTodoDTO = Partial<Omit<ITodo, 'id' | 'timestamp'>>;
export type CreateTodoDTO = Pick<ITodo, 'description' | 'title'>;