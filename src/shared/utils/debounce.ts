import { IDisposable, IListenable, IObservable, createObservable } from "./obs";

export interface IDebounceController<T> extends IListenable<T>, IDisposable {
    value: T;
    update: (value: T) => void,
}

interface CreateDebouceProps<T> {
    initialValue: T,
    delayInMS?: number,
    isEqualsValues?: (current: T, newValue: T) => boolean,
}

export const createDebounce = <T>({
    initialValue,
    delayInMS = 500,
    isEqualsValues,
}: CreateDebouceProps<T>) : IDebounceController<T> => {
    
    const { listen, notify, dispose } = createObservable<T>();
    let currentTimeout : NodeJS.Timeout | null = null;

    const isEquals = isEqualsValues ?? ((a, b) => a === b);

    const clearCurrentTimeout = () => {
        if(currentTimeout == null) return;

        clearTimeout(currentTimeout);
        currentTimeout = null;
    }

    const controller : IDebounceController<T> = {
        listen,
        value: initialValue,
        update(newValue: T) {
            if(isEquals(this.value, newValue)) return;
            clearCurrentTimeout();

            currentTimeout = setTimeout(() => notify(this.value), delayInMS);
            this.value = newValue;
        },
        dispose: () => {
            clearCurrentTimeout();
            dispose();
        },
    };

    return controller;
}
