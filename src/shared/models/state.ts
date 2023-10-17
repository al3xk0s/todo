export interface IAsyncState<T> {
  data?: T;
  isComplete: boolean;
  error?: string;
}
