import 'package:flutter/material.dart';
import 'task.dart';
import 'home_tab.dart';
import 'task_list_tab.dart' as task_list;
import 'complete_task.dart';
import 'add_task_tab.dart' as add_task;
import 'about.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final List<Task> _tasks = [];
  final List<Task> _completedTasks = [];

  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedPriority = 'Medium';
  final List<String> _priorities = ['High', 'Medium', 'Low'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _taskNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _addTask() {
    if (_taskNameController.text.isNotEmpty) {
      setState(() {
        _tasks.add(Task(
          name: _taskNameController.text,
          description: _descriptionController.text,
          priority: _selectedPriority,
        ));
        _taskNameController.clear();
        _descriptionController.clear();
      });
    }
  }

  void _deleteTask(String taskId) {
    setState(() {
      _tasks.removeWhere((task) => task.id == taskId);
    });
  }

  void _completeTask(String taskId) {
    setState(() {
      final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
      if (taskIndex != -1) {
        _tasks[taskIndex].isCompleted = true;
        _tasks[taskIndex].completionDate = DateTime.now();
        _completedTasks.add(_tasks.removeAt(taskIndex));
      }
    });
  }

  void _editTask(Task updatedTask) {
    setState(() {
      final taskIndex = _tasks.indexWhere((task) => task.id == updatedTask.id);
      if (taskIndex != -1) {
        _tasks[taskIndex] = updatedTask;
      }
    });
  }

  void _undoCompleteTask(int index) {
    setState(() {
      _completedTasks[index].isCompleted = false;
      _completedTasks[index].completionDate = null;
      _tasks.add(_completedTasks.removeAt(index));
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'Task Manager',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: TabBar(
            controller: _tabController,
            indicatorColor: Colors.deepPurple,
            labelColor: Colors.deepPurple,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(fontWeight: FontWeight.w500),
            tabs: const [
              Tab(icon: Icon(Icons.home), text: 'Home'),
              Tab(icon: Icon(Icons.list), text: 'Tasks'),
              Tab(icon: Icon(Icons.check_circle), text: 'Done'),
              Tab(icon: Icon(Icons.add), text: 'Add'),
              Tab(icon: Icon(Icons.info_outline), text: 'About'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            HomeTab(tasks: _tasks, completedTasks: _completedTasks),
            task_list.TaskListTab(
              tasks: _tasks.where((task) => !task.isCompleted).toList(),
              onDeleteTask: _deleteTask,
              onCompleteTask: _completeTask,
              onEditTask: _editTask,
            ),
            CompletedTaskListTab(
              completedTasks: _completedTasks,
              onUndoCompleteTask: _undoCompleteTask,
            ),
            add_task.AddTaskTab(
              taskNameController: _taskNameController,
              descriptionController: _descriptionController,
              selectedPriority: _selectedPriority,
              priorities: _priorities,
              onPriorityChanged: (value) =>
                  setState(() => _selectedPriority = value!),
              onAddTask: _addTask,
            ),
            const AboutTab(),
          ],
        ),
      ),
    );
  }
}
