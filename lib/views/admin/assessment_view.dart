import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/state/app_state.dart';

/// Local review screen for the administrator/assessor demo.
class AssessmentView extends StatefulWidget {
  const AssessmentView({super.key});
  @override
  State<AssessmentView> createState() => _AssessmentViewState();
}

class _AssessmentViewState extends State<AssessmentView> {
  String? _trainerId;
  double _dayOne = 80;
  double _dayTwo = 80;
  bool _safetyPassed = true;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final trainerId = _trainerId ?? state.trainers.last.id;
    return Scaffold(
      appBar: AppBar(title: const Text('Trainer assessments')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const Text(
                'Two days. One standard of care.',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Mock assessor workspace. Review client communication and practical skills before activating a new trainer.',
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                initialValue: trainerId,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Trainer application',
                ),
                items: [
                  for (final trainer in state.trainers)
                    DropdownMenuItem(
                      value: trainer.id,
                      child: Text(trainer.name),
                    ),
                ],
                onChanged: (value) => setState(() => _trainerId = value),
              ),
              const SizedBox(height: 24),
              const Text(
                'Day 1 - Knowledge & customer care',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Communication, fitness knowledge, professional conduct, customer interaction and safety awareness.',
              ),
              Slider(
                value: _dayOne,
                min: 0,
                max: 100,
                divisions: 100,
                label: '${_dayOne.round()}%',
                onChanged: (v) => setState(() => _dayOne = v),
              ),
              Text('Day 1 score: ${_dayOne.round()}%'),
              const SizedBox(height: 24),
              const Text(
                'Day 2 - Practical evaluation',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Exercise demonstration, session planning, modifications, time management and customer questions.',
              ),
              Slider(
                value: _dayTwo,
                min: 0,
                max: 100,
                divisions: 100,
                label: '${_dayTwo.round()}%',
                onChanged: (v) => setState(() => _dayTwo = v),
              ),
              Text('Day 2 score: ${_dayTwo.round()}%'),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Critical safety checks passed'),
                subtitle: const Text(
                  'A safety failure requires reassessment regardless of score.',
                ),
                value: _safetyPassed,
                onChanged: (v) => setState(() => _safetyPassed = v),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  state.saveAssessment(
                    trainerId,
                    _dayOne,
                    _dayTwo,
                    _safetyPassed,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Mock assessment saved. Trainer status updated.',
                      ),
                    ),
                  );
                },
                child: const Text('Save assessment decision'),
              ),
              const SizedBox(height: 20),
              Text(
                state.assessmentResults[trainerId] ??
                    'No assessment recorded. Demo passing threshold: 75% on each day and all safety checks passed.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
