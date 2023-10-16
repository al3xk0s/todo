import { TodoList } from "./Todo/TodoList";
import { TodoRepository } from "../services/TodoRepository";
import { ModalProvider } from "./common/modal/ModalProvider";

export function AppBody() {
  return (
    <div className="h-100 w-100">
      <ModalProvider>
        <div className="p-3">
          <TodoList repository={new TodoRepository()} />
        </div>
      </ModalProvider>
    </div>      
  );
}
