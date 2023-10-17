interface TodoWrapperProps {
  children: React.ReactNode,
  onClick?: () => void,
}

export const TodoWrapper = ({children, onClick}: TodoWrapperProps) => {
  return (
    <div onClick={onClick} className="mb-2">
      {children}
    </div>
  );
}
