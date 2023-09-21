typedef Delegate = void Function();
typedef Delegate1<T> = void Function(T arg1);
typedef Delegate2<T1, T2> = void Function(T1 arg1, T2 arg2);
typedef Delegate3<T1, T2, T3> = void Function(T1 arg1, T2 arg2, T3 arg3);

typedef AsyncDelegate = Future<void> Function();
typedef AsyncDelegate1<T> = Future Function(T arg1);
typedef AsyncDelegate2<T1, T2> = Future Function(T1 arg1, T2 arg2);
typedef AsyncDelegate3<T1, T2, T3> = Future Function(T1 arg1, T2 arg2, T3 arg3);
