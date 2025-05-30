import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'task.dart';

class CompletedTaskListTab extends StatelessWidget {
  final List<Task> completedTasks;
  final Function(int) onUndoCompleteTask;

  const CompletedTaskListTab({
    super.key,
    required this.completedTasks,
    required this.onUndoCompleteTask,
  });

  @override
  Widget build(BuildContext context) {
    return completedTasks.isEmpty
        ? Center(
            child: Text(
              "No tasks completed yet.",
              style: TextStyle(fontSize: 16),
            ),
          )
        : ListView.builder(
            itemCount: completedTasks.length,
            itemBuilder: (context, index) => Card(
              elevation: 3,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                leading: Icon(Icons.check_circle, color: Colors.green),
                title: Text(
                  completedTasks[index].name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey,
                  ),
                ),
                subtitle: Text(
                  'Completed on: ${completedTasks[index].completionDate != null ? DateFormat.yMMMMd().add_jm().format(completedTasks[index].completionDate!) : "Unknown"}',
                ),
                trailing: IconButton(
                  icon: Icon(Icons.undo, color: Colors.blue),
                  onPressed: () => onUndoCompleteTask(index),
                  tooltip: 'Undo Completion',
                ),
              ),
            ),
          );
  }
}
