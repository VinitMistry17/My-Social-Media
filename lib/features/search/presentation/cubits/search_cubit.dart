import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_social_media/features/search/presentation/cubits/search_states.dart';
import '../../domain/search_repo.dart';

class SearchCubit extends Cubit<SearchState>{
  final SearchRepo searchRepo;

  // ✅ Use a named parameter with 'required' for clarity and proper initialization.
  // The super() call must also be updated to call the parent class constructor correctly.
  SearchCubit({required this.searchRepo}) : super(SearchInitial());

  Future<void> searchUsers(String query) async {
    if(query.isEmpty){
      emit(SearchInitial());
      return;
    }

    try{
      emit(SearchLoading());
      final users = await searchRepo.searchUsers(query);
      emit(SearchLoaded(users));
    } catch(e){
      emit(SearchError("Error fetching search result"));
    }
  }
}
