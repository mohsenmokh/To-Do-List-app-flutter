import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/data/data.dart';
import 'package:flutter_application_2/data/repo/repository.dart';
import 'package:flutter_application_2/main.dart';
import 'package:flutter_application_2/screens/edit/cubit/edit_task_cubit.dart';
import 'package:flutter_application_2/screens/edit/edit.dart';
import 'package:flutter_application_2/screens/home/bloc/task_list_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'package:provider/provider.dart';

class MyHomePage extends StatelessWidget {
  final TextEditingController controller = TextEditingController();

  MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => BlocProvider<EditTaskCubit>(
                      create: (context) => EditTaskCubit(
                          Task(), context.read<Repository<Task>>()),
                      child: const EditTaskScreen(),
                    )));
          },
          label: Row(
            children: [
              Text(
                'Add New Task',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onPrimary),
              ),
              const Icon(Icons.add)
            ],
          )),
      body: BlocProvider<TaskListBloc>(
        create: (context) => TaskListBloc(context.read<Repository<Task>>()),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                height: 116,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  themeData.colorScheme.primary,
                  themeData.colorScheme.primaryContainer
                ])),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'To Do List',
                            style: themeData.textTheme.titleLarge!
                                .apply(color: themeData.colorScheme.onPrimary),
                          ),
                          Icon(
                            CupertinoIcons.share,
                            color: themeData.colorScheme.onPrimary,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Container(
                          height: 38,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(19),
                              color: themeData.colorScheme.surface,
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 20,
                                    color: Colors.black.withOpacity(0.1))
                              ]),
                          child: Builder(builder: (context) {
                            return TextField(
                              onChanged: (value) {
                                context
                                    .read<TaskListBloc>()
                                    .add(TaskListSearch(value));
                              },
                              controller: controller,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(CupertinoIcons.search),
                                label: Text('Search Tasks...'),
                              ),
                            );
                          }))
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Consumer<Repository<Task>>(
                  builder: (context, value, child) {
                    context.read<TaskListBloc>().add(TaskListStarted());
                    return BlocBuilder<TaskListBloc, TaskListState>(
                        builder: (context, state) {
                      if (state is TaskListSuccess) {
                        return TaskList(
                            items: state.items, themeData: themeData);
                      } else if (state is TaskListEmpty) {
                        return const EmptyState();
                      } else if (state is TaskListLoading ||
                          state is TaskListInitial) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state is TaskListError) {
                        return Center(
                          child: Text(state.errorMessage),
                        );
                      } else {
                        throw Exception('state is not valid...');
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'asset/empty_state.svg',
          width: 120,
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          'Your Task List is Empty',
          style: Theme.of(context).textTheme.bodyLarge,
        )
      ],
    );
  }
}

class TaskList extends StatelessWidget {
  const TaskList({
    super.key,
    required this.items,
    required this.themeData,
  });

  final List<Task> items;
  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: items.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    'Today',
                    style: themeData.textTheme.bodyLarge,
                  ),
                  Container(
                    width: 65,
                    height: 3,
                    decoration: BoxDecoration(
                        color: themeData.colorScheme.primary,
                        borderRadius: BorderRadius.circular(15)),
                  )
                ],
              ),
              MaterialButton(
                  elevation: 0,
                  color: const Color(0xffEAEFF5),
                  textColor: themeData.colorScheme.onSecondary,
                  onPressed: () {
                    context.read<TaskListBloc>().add(TaskListDeleteAll());
                  },
                  child: const Row(
                    children: [
                      Text('Delete All'),
                      SizedBox(
                        width: 2,
                      ),
                      Icon(Icons.delete)
                    ],
                  ))
            ],
          );
        } else {
          final Task task = items[index - 1];
          return _TaskItem(task: task);
        }
      },
    );
  }
}

class _TaskItem extends StatefulWidget {
  const _TaskItem({
    required this.task,
  });

  final Task task;

  @override
  State<_TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<_TaskItem> {
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final Color priorityColor;
    switch (widget.task.priority) {
      case Priority.low:
        priorityColor = lowPriorityColor;
        break;
      case Priority.normal:
        priorityColor = normalPriorityColor;
        break;
      case Priority.high:
        priorityColor = highPriorityColor;
        break;
    }
    return InkWell(
      onTap: () {
        setState(() {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => BlocProvider<EditTaskCubit>(
                  create: (context) => EditTaskCubit(
                      widget.task, context.read<Repository<Task>>()),
                  child: const EditTaskScreen())));
        });
      },
      onLongPress: () {
        widget.task.delete();
      },
      child: Container(
          margin: const EdgeInsets.only(top: 8),
          height: 84,
          decoration: BoxDecoration(
              color: themeData.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1))]),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16,
            ),
            child: Row(
              children: [
                MyCheckBox(
                  value: widget.task.isCompleted,
                  onTap: () {
                    widget.task.isCompleted = !widget.task.isCompleted;
                  },
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Text(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    widget.task.name,
                    style: themeData.textTheme.bodyLarge!.copyWith(
                        fontSize: 16,
                        decoration: widget.task.isCompleted
                            ? TextDecoration.lineThrough
                            : null),
                  ),
                ),
                Container(
                  height: 84,
                  width: 6,
                  decoration: BoxDecoration(
                      color: priorityColor,
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8))),
                )
              ],
            ),
          )),
    );
  }
}

class MyCheckBox extends StatelessWidget {
  final bool value;
  final Function() onTap;

  const MyCheckBox({super.key, required this.value, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
            color: value ? Theme.of(context).colorScheme.primary : null,
            borderRadius: BorderRadius.circular(12),
            border: !value
                ? Border.all(
                    width: 2, color: Theme.of(context).colorScheme.onSecondary)
                : null),
        child: value
            ? Icon(
                CupertinoIcons.check_mark,
                size: 14,
                color: Theme.of(context).colorScheme.onPrimary,
              )
            : null,
      ),
    );
  }
}
