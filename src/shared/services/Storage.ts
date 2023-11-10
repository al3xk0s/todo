import { CreateTodoTitleState } from "../../features/todo/redux/reducers/createTodoTitleReducer";
import { FilterTodoState } from "../../features/todo/redux/reducers/todoFilterReducer";
import { DINamedEntity } from "./ServiceLocator";

export interface ISerializedStoreData {    
    filter: FilterTodoState,
    createTodoTitle: CreateTodoTitleState
}

export interface IStorage {
    save(serialized: ISerializedStoreData) : void;
    load() : ISerializedStoreData | undefined;
}

export class LocalStorage implements IStorage {
    private readonly _key = '_todo_app_cache';

    save(serialized: ISerializedStoreData): void {        
        const {filter, createTodoTitle} = serialized;

        localStorage.setItem(this._key, JSON.stringify({filter, createTodoTitle}));
    }

    load(): ISerializedStoreData | undefined {
        const stringValue = localStorage.getItem(this._key);
        if(stringValue == null) return undefined;

        return JSON.parse(stringValue) as ISerializedStoreData;
    }
}

export const DIStorage : DINamedEntity<IStorage> = { token: 'DIStorage' };
