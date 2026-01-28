import '../domain/exercise_models.dart';
import 'exercise_repository.dart';

/// ===== КАТЕГОРИИ =====

const exerciseCategories = <ExerciseCategory>[
  // Физическое здоровье
  ExerciseCategory(
    id: 'neck',
    title: 'Шея',
    type: HealthType.physical,
    order: 1,
  ),
  ExerciseCategory(
    id: 'shoulders_arms',
    title: 'Плечи и руки',
    type: HealthType.physical,
    order: 2,
  ),
  ExerciseCategory(
    id: 'back_lower',
    title: 'Спина и поясница',
    type: HealthType.physical,
    order: 3,
  ),
  ExerciseCategory(
    id: 'eyes',
    title: 'Глаза',
    type: HealthType.physical,
    order: 4,
  ),

  // Ментальное здоровье
  ExerciseCategory(
    id: 'relaxation',
    title: 'Снятие напряжения',
    type: HealthType.mental,
    order: 1,
  ),
  ExerciseCategory(
    id: 'attention_switch',
    title: 'Переключение внимания',
    type: HealthType.mental,
    order: 2,
  ),
  ExerciseCategory(
    id: 'emotional_balance',
    title: 'Эмоциональная стабилизация',
    type: HealthType.mental,
    order: 3,
  ),
];

/// ===== УПРАЖНЕНИЯ =====

const exercises = <Exercise>[
  // --- ШЕЯ ---
  Exercise(
    id: 'neck_01',
    categoryId: 'neck',
    type: HealthType.physical,
    title: 'Наклоны головы вправо и влево',
    description: 'Медленно наклоняйте голову к правому и левому плечу.',
    defaultDurationSec: 40,
  ),
  Exercise(
    id: 'neck_02',
    categoryId: 'neck',
    type: HealthType.physical,
    title: 'Повороты головы с фиксацией',
    description:
    'Поверните голову в сторону и удерживайте положение 3–5 секунд, затем смените сторону.',
    defaultDurationSec: 40,
  ),
  Exercise(
    id: 'neck_03',
    categoryId: 'neck',
    type: HealthType.physical,
    title: 'Вытяжение шеи вверх',
    description:
    'Тянитесь макушкой вверх, плечи при этом остаются опущенными и расслабленными.',
    defaultDurationSec: 40,
  ),

  // --- ПЛЕЧИ И РУКИ ---
  Exercise(
    id: 'shoulders_01',
    categoryId: 'shoulders_arms',
    type: HealthType.physical,
    title: 'Подъём и опускание плеч',
    description:
    'Медленно поднимайте плечи вверх, затем опускайте их вниз, расслабляя мышцы.',
    defaultDurationSec: 40,
  ),
  Exercise(
    id: 'shoulders_02',
    categoryId: 'shoulders_arms',
    type: HealthType.physical,
    title: 'Сведение лопаток сидя',
    description:
    'Сидя на стуле, медленно сведите лопатки вместе, затем расслабьтесь.',
    defaultDurationSec: 40,
  ),
  Exercise(
    id: 'arms_01',
    categoryId: 'shoulders_arms',
    type: HealthType.physical,
    title: 'Растяжка предплечий',
    description:
    'Вытяните руку вперёд и мягко тяните ладонь на себя, затем от себя. Повторите другой рукой.',
    defaultDurationSec: 40,
  ),

  // --- СПИНА И ПОЯСНИЦА ---
  Exercise(
    id: 'back_01',
    categoryId: 'back_lower',
    type: HealthType.physical,
    title: 'Потягивание вверх сидя',
    description:
    'Сидя на стуле, поднимите руки вверх и мягко потянитесь всем телом.',
    defaultDurationSec: 40,
  ),
  Exercise(
    id: 'back_02',
    categoryId: 'back_lower',
    type: HealthType.physical,
    title: 'Наклон корпуса вперёд',
    description:
    'С прямой спиной выполните лёгкий наклон корпуса вперёд, затем вернитесь назад.',
    defaultDurationSec: 40,
  ),
  Exercise(
    id: 'back_03',
    categoryId: 'back_lower',
    type: HealthType.physical,
    title: 'Скручивание корпуса сидя',
    description:
    'Сидя на стуле, поверните корпус в сторону, держась за спинку стула.',
    defaultDurationSec: 40,
  ),

  // --- ГЛАЗА ---
  Exercise(
    id: 'eyes_01',
    categoryId: 'eyes',
    type: HealthType.physical,
    title: 'Осознанное моргание',
    description:
    'Часто и мягко моргайте, полностью закрывая и открывая глаза.',
    defaultDurationSec: 40,
  ),
  Exercise(
    id: 'eyes_02',
    categoryId: 'eyes',
    type: HealthType.physical,
    title: 'Мягкое закрытие глаз',
    description:
    'Закройте глаза и расслабьте веки, не сжимая их.',
    defaultDurationSec: 40,
  ),
  Exercise(
    id: 'eyes_03',
    categoryId: 'eyes',
    type: HealthType.physical,
    title: 'Зажмуривание и расслабление',
    description:
    'Лёгко зажмурьте глаза, затем полностью расслабьте их.',
    defaultDurationSec: 40,
  ),
  Exercise(
    id: 'eyes_04',
    categoryId: 'eyes',
    type: HealthType.physical,
    title: 'Движения глазами вверх и вниз',
    description:
    'Медленно переводите взгляд вверх и вниз.',
    defaultDurationSec: 40,
  ),
  Exercise(
    id: 'eyes_05',
    categoryId: 'eyes',
    type: HealthType.physical,
    title: 'Движения глазами вправо и влево',
    description:
    'Медленно переводите взгляд вправо и влево.',
    defaultDurationSec: 40,
  ),
  Exercise(
    id: 'eyes_06',
    categoryId: 'eyes',
    type: HealthType.physical,
    title: 'Круговые движения глазами',
    description:
    'Опишите взглядом круг по часовой стрелке и против неё.',
    defaultDurationSec: 40,
  ),

  // --- СНЯТИЕ НАПРЯЖЕНИЯ ---
  Exercise(
    id: 'relax_01',
    categoryId: 'relaxation',
    type: HealthType.mental,
    title: 'Медленное дыхание через нос',
    description:
    'Медленно вдыхайте через нос на 4–6 секунд, затем спокойно выдыхайте.',
    defaultDurationSec: 40,
  ),
  Exercise(
    id: 'relax_02',
    categoryId: 'relaxation',
    type: HealthType.mental,
    title: 'Расслабление челюсти и плеч',
    description:
    'Осознанно расслабьте челюсть, затем опустите и расслабьте плечи.',
    defaultDurationSec: 40,
  ),
  Exercise(
    id: 'relax_03',
    categoryId: 'relaxation',
    type: HealthType.mental,
    title: 'Выдох с удлинением',
    description:
    'Сделайте спокойный вдох и более длинный, медленный выдох.',
    defaultDurationSec: 40,
  ),

  // --- ПЕРЕКЛЮЧЕНИЕ ВНИМАНИЯ ---
  Exercise(
    id: 'focus_01',
    categoryId: 'attention_switch',
    type: HealthType.mental,
    title: 'Фокус на внешнем звуке',
    description:
    'Выберите один звук вокруг и удерживайте на нём внимание.',
    defaultDurationSec: 40,
  ),
  Exercise(
    id: 'focus_02',
    categoryId: 'attention_switch',
    type: HealthType.mental,
    title: 'Отсчёт вдохов',
    description:
    'Медленно отсчитайте 5 спокойных вдохов и выдохов.',
    defaultDurationSec: 40,
  ),
  Exercise(
    id: 'focus_03',
    categoryId: 'attention_switch',
    type: HealthType.mental,
    title: 'Ощущение опоры стоп',
    description:
    'Сконцентрируйтесь на ощущении стоп, соприкасающихся с полом.',
    defaultDurationSec: 40,
  ),

  // --- ЭМОЦИОНАЛЬНАЯ СТАБИЛИЗАЦИЯ ---
  Exercise(
    id: 'emotion_01',
    categoryId: 'emotional_balance',
    type: HealthType.mental,
    title: 'Осознание текущего чувства',
    description:
    'Мысленно задайте себе вопрос: «Что я сейчас чувствую?»',
    defaultDurationSec: 40,
  ),
  Exercise(
    id: 'emotion_02',
    categoryId: 'emotional_balance',
    type: HealthType.mental,
    title: 'Нейтральная опорная мысль',
    description:
    'Произнесите про себя короткую мысль: «Я здесь и сейчас».',
    defaultDurationSec: 40,
  ),
  Exercise(
    id: 'emotion_03',
    categoryId: 'emotional_balance',
    type: HealthType.mental,
    title: 'Визуализация завершённой задачи',
    description:
    'Представьте, что текущая задача уже успешно завершена.',
    defaultDurationSec: 40,
  ),
];

final exerciseRepository = ExerciseRepository(
  categories: exerciseCategories,
  exercises: exercises,
);
