void dfs<T>({
  required T root,
  required Iterable<T> Function(T current) getChildrens,
  required void Function(T? root, T current) delegate,
}) {
  for(final current in getChildrens(root)) {
    dfs(root: current, getChildrens: getChildrens, delegate: delegate);
    delegate(root, current);
  }
  delegate(null, root);
}