import 'package:bloc/bloc.dart';
import 'package:flutter_application_2/data/data.dart';
import 'package:flutter_application_2/data/repo/repository.dart';
import 'package:meta/meta.dart';

part 'edit_task_state.dart';

class EditTaskCubit extends Cubit<EditTaskState> {
  final Task _task;
  final Repository<Task> repository;
  EditTaskCubit(this._task, this.repository) : super(EditTaskInitial(_task));

  void onSaveChangesClick() {
    repository.createOrUpdate(_task);
  }

  void onTextChanged(String text) {
    _task.name = text;
  }

  void onPriorityChanged(Priority priority) {
    _task.priority = priority;
    emit(EditTaskPriorityChange(_task));
  }
}
