import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/data/data.dart';

import 'package:flutter_application_2/main.dart';
import 'package:flutter_application_2/screens/edit/cubit/edit_task_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditTaskScreen extends StatefulWidget {
  const EditTaskScreen({
    super.key,
  });

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(
        text: context.read<EditTaskCubit>().state.task.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: themeData.colorScheme.surface,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            context.read<EditTaskCubit>().onSaveChangesClick();

            Navigator.of(context).pop();
          },
          label: Row(
            children: [
              Text(
                'Save Changes',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onPrimary),
              ),
              const SizedBox(
                width: 4,
              ),
              const Icon(Icons.save)
            ],
          )),
      appBar: AppBar(
        backgroundColor: themeData.colorScheme.surface,
        title: const Text('Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
          child: Column(
            children: [
              BlocBuilder<EditTaskCubit, EditTaskState>(
                builder: (context, state) {
                  final priority = state.task.priority;
                  return Flex(
                    direction: Axis.horizontal,
                    children: [
                      Flexible(
                          flex: 1,
                          child: PriorityCheckBox(
                            name: 'high',
                            isSelected: priority == Priority.high,
                            color: highPriorityColor,
                            onTap: () {
                              context
                                  .read<EditTaskCubit>()
                                  .onPriorityChanged(Priority.high);
                            },
                          )),
                      const SizedBox(
                        width: 8,
                      ),
                      Flexible(
                          flex: 1,
                          child: PriorityCheckBox(
                            name: 'normal',
                            isSelected: priority == Priority.normal,
                            color: normalPriorityColor,
                            onTap: () {
                              context
                                  .read<EditTaskCubit>()
                                  .onPriorityChanged(Priority.normal);
                            },
                          )),
                      const SizedBox(
                        width: 8,
                      ),
                      Flexible(
                          flex: 1,
                          child: PriorityCheckBox(
                            name: 'low',
                            isSelected: priority == Priority.low,
                            color: lowPriorityColor,
                            onTap: () {
                              context
                                  .read<EditTaskCubit>()
                                  .onPriorityChanged(Priority.low);
                            },
                          )),
                    ],
                  );
                },
              ),
              TextField(
                onChanged: (value) {
                  context.read<EditTaskCubit>().onTextChanged(value);
                },
                controller: _controller,
                decoration: InputDecoration(
                    label: Text(
                  'Add a task for today...',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.w200),
                )),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PriorityCheckBox extends StatelessWidget {
  final String name;
  final bool isSelected;
  final Color color;
  final GestureTapCallback onTap;
  const PriorityCheckBox(
      {super.key,
      required this.name,
      required this.isSelected,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
                width: 2,
                color: themeData.colorScheme.onSecondary.withOpacity(0.2))),
        child: Stack(
          children: [
            Center(
              child: Text(
                name,
                style: themeData.textTheme.bodyLarge!.copyWith(fontSize: 16),
              ),
            ),
            Positioned(
              right: 8,
              bottom: 0,
              top: 0,
              child: Center(
                child: ShapeCheckBox(
                  value: isSelected,
                  color: color,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ShapeCheckBox extends StatelessWidget {
  final bool value;
  final Color color;

  const ShapeCheckBox({super.key, required this.value, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: value
          ? Icon(
              CupertinoIcons.check_mark,
              size: 12,
              color: Theme.of(context).colorScheme.onPrimary,
            )
          : null,
    );
  }
}
