part of 'get_state.dart';

typedef StateWidgetBuilder<S> = Widget Function(BuildContext context, S state);

abstract class GetStateView<S, C extends IGetStateController<S>> extends GetView<C> {
  const GetStateView({super.key});

  void mapBuildersToStates(
    void Function<T extends S>(StateWidgetBuilder<T> builder) mapBuilderByStateType,
    void Function(S state, StateWidgetBuilder<S> builder) mapBuilderByState,
  );

  void onState(S state) {

  }

  void didChangeDependencies(GetXState<C> getState, IAddOnlyDisposeWrapper disposeWrapper) {
    disposeWrapper.addStreamDisposer(controller.state.listen(onState));
  }

  void dispose(GetXState<C> getState) {
    
  }

  @override
  Widget build(BuildContext context) {
    final Map<S, StateWidgetBuilder<S>> constStateBuilderMap = {};
    final Map<Type, StateWidgetBuilder<S>> typeStateBuilderMap = {};

    void mapBuilderByStateType<T extends S>(StateWidgetBuilder<T> builder) {
      typeStateBuilderMap[T] = (c, s) => builder(c, s as T);
    }
    
    mapBuildersToStates(
      mapBuilderByStateType, 
      (s, b) => constStateBuilderMap[s] = b,
    );

    IDisposeWrapper disposeWrapper = DisposeWrapper();

    return GetX<C>(
      builder: (controller) => _getWidgetAtState(
        constStateBuilderMap,
        typeStateBuilderMap,
        context,
        controller.state.value,
      ),
      didChangeDependencies: (state) => didChangeDependencies(state, disposeWrapper),
      dispose: (state) {
        dispose(state);
        disposeWrapper.dispose();
      }
    );
  }

  Widget _getWidgetAtState(
    Map<S, StateWidgetBuilder<S>> constStateBuilderMap,
    Map<Type, StateWidgetBuilder<S>> typeStateBuilderMap,
    BuildContext context, 
    S state,
  ) {
    final builder = typeStateBuilderMap[state.runtimeType] ?? constStateBuilderMap[state];
    if(builder == null) throw Exception('Unhandled state');
    return builder(context, state);
  }
}

class GetStateWidget<S, C extends IGetStateController<S>> extends GetStateView<S, C> {
  const GetStateWidget({
    super.key,
    required void Function(
      void Function<T extends S>(StateWidgetBuilder<T> builder) mapBuilderByStateType,
      void Function(S state, StateWidgetBuilder<S> builder) mapBuilderByState,
    ) mapBuildersToStates,
    void Function(GetXState<C>, IAddOnlyDisposeWrapper)? didChangeDependencies,
    void Function(GetXState<C>)? dispose,
  })  : _dispose = dispose,
        _didChangeDependencies = didChangeDependencies,
        _mapBuildersToStates = mapBuildersToStates;

  final void Function (
    void Function<T extends S>(StateWidgetBuilder<T> builder) mapBuilderByStateType,
    void Function(S state, StateWidgetBuilder<S> builder) mapBuilderByState,
  ) _mapBuildersToStates;

  @override
  void mapBuildersToStates(
    void Function<T extends S>(StateWidgetBuilder<T> builder) mapBuilderByStateType,
    void Function(S state, StateWidgetBuilder<S> builder) mapBuilderByState,
  ) =>
    _mapBuildersToStates(mapBuilderByStateType, mapBuilderByState);

  final void Function(GetXState<C> getState, IAddOnlyDisposeWrapper disposeWrapper)? _didChangeDependencies;

  @override
  void didChangeDependencies(GetXState<C> getState, IAddOnlyDisposeWrapper disposeWrapper) {
    if(_didChangeDependencies == null) return super.didChangeDependencies(getState, disposeWrapper);
    super.didChangeDependencies(getState, disposeWrapper);
    _didChangeDependencies!(getState, disposeWrapper);
  }

  final void Function(GetXState<C> getState)? _dispose;

  @override
  void dispose(GetXState<C> getState) {
    if(_dispose == null) return super.dispose(getState);
    _dispose!(getState);
    super.dispose(getState);
  }
}