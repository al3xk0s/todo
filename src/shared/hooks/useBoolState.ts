import { useState } from "react"

export const useBoolState = (initial: boolean | undefined = undefined) => {
  const [state, setState] = useState(initial);
  const toggleState = () => setState((prev) => !prev);

  return [state, setState, toggleState]
}
