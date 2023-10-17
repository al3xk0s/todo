import { TodoList } from "../../features/todo/list/TodoList";
import { MyModal } from "../../shared/ui/modal/Modal";

export function AppBody() {
  return (
    <div className="h-100 w-100">      
      <div className="p-3">
        <MyModal />
        <TodoList />
      </div>      
    </div>      
  );
}
