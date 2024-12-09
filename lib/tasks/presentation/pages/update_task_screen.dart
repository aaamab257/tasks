import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:task_manager_app/components/widgets.dart';
import 'package:task_manager_app/tasks/data/local/model/task_model.dart';
import 'package:task_manager_app/utils/font_sizes.dart';

import '../../../components/custom_app_bar.dart';
import '../../../utils/color_palette.dart';
import '../../../utils/util.dart';
import '../bloc/tasks_bloc.dart';
import '../../../components/build_text_field.dart';

class UpdateTaskScreen extends StatefulWidget {
  final TaskModel taskModel;

  const UpdateTaskScreen({super.key, required this.taskModel});

  @override
  State<UpdateTaskScreen> createState() => _UpdateTaskScreenState();
}

class _UpdateTaskScreenState extends State<UpdateTaskScreen> {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  TimeOfDay? fromTime, toTime;

  _onRangeSelected(DateTime? start, DateTime? end, DateTime focusDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusDay;
      _rangeStart = start;
      _rangeEnd = end;
    });
  }

  @override
  void dispose() {
    title.dispose();
    description.dispose();
    super.dispose();
  }

  @override
  void initState() {
    title.text = widget.taskModel.title;
    description.text = widget.taskModel.description;
    _selectedDay = _focusedDay;
    _rangeStart = widget.taskModel.startDateTime;
    _rangeEnd = widget.taskModel.stopDateTime;
    // fromTime = widget.taskModel.startTime != null
    //     ? TimeOfDay(
    //         hour: int.parse(widget.taskModel.startTime!.split(":")[0]),
    //         minute: int.parse(widget.taskModel.startTime!.split(":")[1]))
    //     : null;
    // toTime = widget.taskModel.endTime != null
    //     ? TimeOfDay(
    //         hour: int.parse(widget.taskModel.endTime!.split(":")[0]),
    //         minute: int.parse(widget.taskModel.endTime!.split(":")[1]))
    //     : null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
        child: Scaffold(
            backgroundColor: kWhiteColor,
            appBar: const CustomAppBar(
              title: 'Update Task',
            ),
            body: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => FocusScope.of(context).unfocus(),
                child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: BlocConsumer<TasksBloc, TasksState>(
                        listener: (context, state) {
                      if (state is UpdateTaskFailure) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(getSnackBar(state.error, kRed));
                      }
                      if (state is UpdateTaskSuccess) {
                        Navigator.pop(context);
                      }
                    }, builder: (context, state) {
                      return ListView(
                        children: [
                          TableCalendar(
                            calendarFormat: _calendarFormat,
                            startingDayOfWeek: StartingDayOfWeek.monday,
                            availableCalendarFormats: const {
                              CalendarFormat.month: 'Month',
                              CalendarFormat.week: 'Week',
                            },
                            rangeSelectionMode: RangeSelectionMode.toggledOn,
                            focusedDay: _focusedDay,
                            firstDay: DateTime.utc(2023, 1, 1),
                            lastDay: DateTime.utc(2030, 1, 1),
                            onPageChanged: (focusDay) {
                              _focusedDay = focusDay;
                            },
                            selectedDayPredicate: (day) =>
                                isSameDay(_selectedDay, day),
                            rangeStartDay: _rangeStart,
                            rangeEndDay: _rangeEnd,
                            onFormatChanged: (format) {
                              if (_calendarFormat != format) {
                                setState(() {
                                  _calendarFormat = format;
                                });
                              }
                            },
                            onRangeSelected: _onRangeSelected,
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            decoration: BoxDecoration(
                                color: kPrimaryColor.withOpacity(.1),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5))),
                            child: buildText(
                                _rangeStart != null && _rangeEnd != null
                                    ? 'Task starting at ${formatDate(dateTime: _rangeStart.toString())} - ${formatDate(dateTime: _rangeEnd.toString())}'
                                    : 'Select a date range',
                                kPrimaryColor,
                                textSmall,
                                FontWeight.w400,
                                TextAlign.start,
                                TextOverflow.clip),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  decoration: BoxDecoration(
                                    color: kPrimaryColor.withOpacity(.1),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                  ),
                                  child: GestureDetector(
                                    onTap: () async {
                                      fromTime = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      );
                                      if (fromTime != null) {
                                        setState(() {});
                                      }
                                    },
                                    child: buildText(
                                      fromTime == null
                                          ? 'Task starting at ${widget.taskModel.startTime}'
                                          : 'Task starting at ${fromTime!.format(context)}',
                                      kPrimaryColor,
                                      textSmall,
                                      FontWeight.w400,
                                      TextAlign.start,
                                      TextOverflow.clip,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  decoration: BoxDecoration(
                                    color: kPrimaryColor.withOpacity(.1),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                  ),
                                  child: GestureDetector(
                                    onTap: () async {
                                      toTime = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      );
                                      if (toTime != null) {
                                        setState(() {
                                          // Handle the selected time
                                        });
                                      }
                                    },
                                    child: buildText(
                                      toTime == null
                                          ? 'Task ending at ${widget.taskModel.endTime}'
                                          : 'Task ending at ${toTime!.format(context)}',
                                      kPrimaryColor,
                                      textSmall,
                                      FontWeight.w400,
                                      TextAlign.start,
                                      TextOverflow.clip,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          buildText(
                              'Title',
                              kBlackColor,
                              textMedium,
                              FontWeight.bold,
                              TextAlign.start,
                              TextOverflow.clip),
                          const SizedBox(
                            height: 10,
                          ),
                          BuildTextField(
                              hint: "Task Title",
                              controller: title,
                              inputType: TextInputType.text,
                              fillColor: kWhiteColor,
                              onChange: (value) {}),
                          const SizedBox(
                            height: 20,
                          ),
                          buildText(
                              'Description',
                              kBlackColor,
                              textMedium,
                              FontWeight.bold,
                              TextAlign.start,
                              TextOverflow.clip),
                          const SizedBox(
                            height: 10,
                          ),
                          BuildTextField(
                              hint: "Task Description",
                              controller: description,
                              inputType: TextInputType.multiline,
                              fillColor: kWhiteColor,
                              onChange: (value) {}),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: size.width,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          kPrimaryColor),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          10), // Adjust the radius as needed
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  var taskModel = TaskModel(
                                      id: widget.taskModel.id,
                                      title: title.text,
                                      description: description.text,
                                      completed: widget.taskModel.completed,
                                      startDateTime: _rangeStart,
                                      stopDateTime: _rangeEnd,
                                      startTime: fromTime!.format(context),
                                      endTime: toTime!.format(context));
                                  context.read<TasksBloc>().add(
                                      UpdateTaskEvent(taskModel: taskModel));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: buildText(
                                      'Update',
                                      kWhiteColor,
                                      textMedium,
                                      FontWeight.w600,
                                      TextAlign.center,
                                      TextOverflow.clip),
                                )),
                          ),
                        ],
                      );
                    })))));
  }
}
