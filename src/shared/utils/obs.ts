import {v4 as uuid} from 'uuid';

export interface IDisposable {
    dispose() : void;
}

export type IListener<T> = (value: T) => any;
export type IVoidCallback = () => any;

export type IDisposer = () => void;

export interface IListenable<T> {
    listen(listener: IListener<T>) : IDisposer;
}

export interface IObservable<T> extends IDisposable, IListenable<T> {
    notify(value: T): void;
}

export const createObservable = <T>() : IObservable<T> => {
    const listeners : Map<string, IListener<T>> = new Map();

    return {
        notify: (value) => listeners.forEach(l => l(value)),
        listen: (l) => {
            const id = uuid();
            listeners.set(id, l);

            return () => listeners.delete(id);
        },
        dispose: () => listeners.clear(),
    };
}

export interface IDisposeWrapper extends IDisposable {
    addDisposer(disposer: IDisposer) : void;
    clear() : void;
}

export const createDisposeWrapper = () : IDisposeWrapper => {
    const disposers : Map<string, IDisposer> = new Map();

    return {
        addDisposer: (d) => disposers.set(uuid(), d),
        dispose: () => {
            for(const [id, dispose] of disposers.entries()) {
                dispose();
                disposers.delete(id);
            }
        },
        clear: () => disposers.clear(),
    };
};
