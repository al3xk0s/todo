export const containsAnyClass = (classList?: DOMTokenList, ...classes: string[]) => {
  if(classList == null) return false;

  for(const className of classes) {
    if(classList.contains(className)) return true;
  }

  return false;
};

export const elementContainsAnyClass = (element: EventTarget, ...classes: string[]) => containsAnyClass((element as HTMLElement).classList, ...classes);