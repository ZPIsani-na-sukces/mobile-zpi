import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/routine/controllers/create_routine_task_controller.dart';
import 'package:mobile_zpi/features/routine/data/routine_task_draft.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';
import 'package:mobile_zpi/widgets/app_button.dart';
import 'package:mobile_zpi/widgets/app_text_input.dart';
import 'package:mobile_zpi/widgets/back_scaffold.dart';

const _types = <String, String>{
  'medication': 'Lek',
  'meal': 'Posiłek',
  'hydration': 'Nawodnienie',
};

const _dayLabels = ['Pn', 'Wt', 'Śr', 'Cz', 'Pt', 'So', 'Nd'];

@RoutePage()
class CreateRoutineTaskView extends HookConsumerWidget {
  const CreateRoutineTaskView({super.key, required this.seniorId});

  final String seniorId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleController = useTextEditingController();
    final instructionsController = useTextEditingController();
    final timeController = useTextEditingController();
    final type = useState('medication');
    final startsOn = useState(DateTime.now());
    final endsOn = useState<DateTime?>(null);
    final days = useState<Set<int>>({1, 2, 3, 4, 5, 6, 7});
    final times = useState<List<String>>([]);
    final titleError = useState<String?>(null);
    final instructionsError = useState<String?>(null);
    final timeError = useState<String?>(null);
    final formError = useState<String?>(null);
    final createState = ref.watch(createRoutineTaskControllerProvider);
    final saving = createState.isLoading;

    Future<void> pickDate({required bool isEnd}) async {
      final initial = isEnd ? (endsOn.value ?? startsOn.value) : startsOn.value;
      final picked = await showDatePicker(
        context: context,
        initialDate: initial,
        firstDate: DateTime(2020),
        lastDate: DateTime(2100),
      );
      if (picked == null) return;
      if (isEnd) {
        endsOn.value = picked;
      } else {
        startsOn.value = picked;
      }
    }

    void addTime() {
      final raw = timeController.text.trim();
      final match = RegExp(r'^([01][0-9]|2[0-3]):[0-5][0-9]$').hasMatch(raw);
      if (!match) {
        timeError.value = 'Wpisz godzinę w formacie 08:30';
        return;
      }
      final value = '$raw:00';
      if (times.value.contains(value)) {
        timeError.value = 'Ta godzina jest już dodana';
        return;
      }
      if (times.value.length >= 12) {
        timeError.value = 'Możesz dodać najwyżej 12 godzin';
        return;
      }
      timeError.value = null;
      times.value = [...times.value, value]..sort();
      timeController.clear();
    }

    Future<void> onSave() async {
      final title = titleController.text.trim();
      final instructions = instructionsController.text.trim();
      titleError.value = title.isEmpty
          ? 'Wpisz tytuł'
          : (title.length > 150 ? 'Tytuł jest za długi' : null);
      instructionsError.value = instructions.isEmpty
          ? 'Wpisz instrukcję'
          : (instructions.length > 2000 ? 'Instrukcja jest za długa' : null);
      formError.value = null;
      if (days.value.isEmpty) {
        formError.value = 'Wybierz przynajmniej jeden dzień.';
      }
      if (times.value.isEmpty) {
        timeError.value = 'Dodaj przynajmniej jedną godzinę';
      }
      if (endsOn.value != null && endsOn.value!.isBefore(startsOn.value)) {
        formError.value = 'Data końca nie może być wcześniejsza niż początek.';
      }
      if (titleError.value != null ||
          instructionsError.value != null ||
          timeError.value != null ||
          formError.value != null) {
        return;
      }

      await ref
          .read(createRoutineTaskControllerProvider.notifier)
          .create(
            seniorId,
            RoutineTaskDraft(
              type: type.value,
              title: title,
              instructions: instructions,
              startsOn: startsOn.value,
              endsOn: endsOn.value,
              daysOfWeek: (days.value.toList()..sort()),
              times: times.value,
            ),
          );
      if (!context.mounted) return;
      final next = ref.read(createRoutineTaskControllerProvider);
      if (next.hasError) {
        formError.value = _createError(next.error!);
        return;
      }
      context.router.pop();
    }

    return BackScaffold(
      title: 'Nowe zadanie',
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text(
            'Rodzaj',
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.onBackground,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            children: [
              for (final entry in _types.entries)
                ChoiceChip(
                  label: Text(entry.value),
                  selected: type.value == entry.key,
                  onSelected: saving ? null : (_) => type.value = entry.key,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextInput(
            controller: titleController,
            label: 'Tytuł',
            textCapitalization: TextCapitalization.sentences,
            errorText: titleError.value,
            onChanged: (_) => titleError.value = null,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextInput(
            controller: instructionsController,
            label: 'Instrukcja',
            textCapitalization: TextCapitalization.sentences,
            errorText: instructionsError.value,
            onChanged: (_) => instructionsError.value = null,
          ),
          const SizedBox(height: AppSpacing.md),
          _DateField(
            label: 'Początek',
            value: _formatDate(startsOn.value),
            onPressed: saving ? null : () => pickDate(isEnd: false),
          ),
          const SizedBox(height: AppSpacing.md),
          _DateField(
            label: 'Koniec',
            value: endsOn.value == null
                ? 'Bez daty końca'
                : _formatDate(endsOn.value!),
            onPressed: saving ? null : () => pickDate(isEnd: true),
            onClear: endsOn.value == null || saving
                ? null
                : () => endsOn.value = null,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Dni',
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.onBackground,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            children: [
              for (var index = 0; index < _dayLabels.length; index++)
                FilterChip(
                  label: Text(_dayLabels[index]),
                  selected: days.value.contains(index + 1),
                  onSelected: saving
                      ? null
                      : (selected) {
                          final next = {...days.value};
                          if (selected) {
                            next.add(index + 1);
                          } else {
                            next.remove(index + 1);
                          }
                          days.value = next;
                        },
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextInput(
            controller: timeController,
            label: 'Godzina',
            hintText: '08:30',
            keyboardType: TextInputType.datetime,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[0-9:]')),
              LengthLimitingTextInputFormatter(5),
            ],
            errorText: timeError.value,
            onChanged: (_) => timeError.value = null,
            onSubmitted: (_) => addTime(),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppButton.secondary(
            label: 'Dodaj godzinę',
            onPressed: saving ? null : addTime,
          ),
          if (times.value.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              children: [
                for (final time in times.value)
                  InputChip(
                    label: Text(time.substring(0, 5)),
                    onDeleted: saving
                        ? null
                        : () => times.value = [
                            for (final item in times.value)
                              if (item != time) item,
                          ],
                  ),
              ],
            ),
          ],
          if (formError.value != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              formError.value!,
              style: AppTypography.bodyMedium.copyWith(color: AppColors.error),
            ),
          ],
          const SizedBox(height: AppSpacing.xl),
          AppButton.primary(
            label: 'Zapisz zadanie',
            onPressed: saving ? null : onSave,
          ),
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.onPressed,
    this.onClear,
  });

  final String label;
  final String value;
  final VoidCallback? onPressed;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppButton.secondary(
            label: '$label: $value',
            onPressed: onPressed,
          ),
        ),
        if (onClear != null) ...[
          const SizedBox(width: AppSpacing.sm),
          AppButton.text(label: 'Wyczyść', onPressed: onClear),
        ],
      ],
    );
  }
}

String _formatDate(DateTime value) {
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  return '${value.year}-$month-$day';
}

String _createError(Object error) {
  if (error is DioException && error.response?.statusCode == 403) {
    return 'Tylko opiekun może dodać zadanie.';
  }
  return 'Nie udało się zapisać zadania. Spróbuj ponownie.';
}
