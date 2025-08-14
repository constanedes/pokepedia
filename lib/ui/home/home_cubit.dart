import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  Future<void> navigateToList() async {
    emit(HomeLoading());

    emit(HomeNavigate());
  }
}
