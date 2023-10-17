import { ChangeEvent, KeyboardEvent, useRef, useState } from "react"

export interface IHasValue {
  value: string,
}

export interface InputStateBind<T extends IHasValue = IHasValue> {
  value: string,
  onChange: (ev: ChangeEvent<T>) => void,
}

export type InputRefBind = ReturnType<typeof useRefInput>['bind'];

export const useStateInput = <T extends {value: string} = HTMLInputElement>(initialValue: string = '') => {
  const [value, setValue] = useState(initialValue);
  
  return {
    value,
    clear: () => setValue(''),
    setValue: (value: string) => setValue(value),
    bind: {
      value,
      onChange: (ev: ChangeEvent<T>) => setValue((ev.target as T).value),
    },
  }
}

export const useRefInput = <T extends {value: string} = HTMLInputElement>() => {
  const ref = useRef<T>(null);

  const setValue = (newValue: string) => {
    if(ref.current == null) return;
    ref.current.value = newValue;
  }

  return {
    ref,
    clear: () => setValue(''),
    setValue,
    bind: {
      ref,
    },
  }
}

