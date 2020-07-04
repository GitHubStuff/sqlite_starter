import 'package:bloc/bloc.dart';
import 'package:tracers/tracers.dart' as Log;

class LoggingBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    Log.t('{logging_bloc_delegate.dart} ${event.toString()}');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    Log.v('{logging_bloc_delegate.dart} ${transition.toString()}');
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    Log.e('{logging_bloc_delegate.dart} ${error.toString()}');
  }
}
