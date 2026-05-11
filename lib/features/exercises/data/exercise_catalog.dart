import '../domain/exercise_models.dart';
import 'exercise_repository.dart';

/// Каталог категорий упражнений - 7 категорий (4 физические + 3 ментальные).
const exerciseCategories = <ExerciseCategory>[
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

  ExerciseCategory(
    id: 'wrists_hands',
    title: 'Кисти и запястья',
    type: HealthType.physical,
    order: 5,
  ),

  ExerciseCategory(
    id: 'legs_feet',
    title: 'Ноги и стопы',
    type: HealthType.physical,
    order: 6,
  ),

  ExerciseCategory(
    id: 'posture_alignment',
    title: 'Осанка',
    type: HealthType.physical,
    order: 7,
  ),

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

  ExerciseCategory(
    id: 'breathing',
    title: 'Дыхание',
    type: HealthType.mental,
    order: 4,
  ),

  ExerciseCategory(
    id: 'cognitive_unload',
    title: 'Когнитивная разгрузка',
    type: HealthType.mental,
    order: 5,
  ),
];

const exercises = <Exercise>[
  // ── Шея ────────────────────────────────────────────────────────────────
  Exercise(
    id: 'neck_01',
    categoryId: 'neck',
    type: HealthType.physical,
    title: 'Наклоны головы вправо и влево',
    description: 'Медленно наклоняйте голову к правому и левому плечу.',
    titleEn: 'Side head tilts',
    descriptionEn: 'Slowly tilt your head toward your right and left shoulder.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'neck_02',
    categoryId: 'neck',
    type: HealthType.physical,
    title: 'Повороты головы с фиксацией',
    description:
        'Поверните голову в сторону и удерживайте положение 3–5 секунд, затем смените сторону.',
    titleEn: 'Head turns with hold',
    descriptionEn:
        'Turn your head to one side and hold for 3–5 seconds, then switch sides.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'neck_03',
    categoryId: 'neck',
    type: HealthType.physical,
    title: 'Вытяжение шеи вверх',
    description:
        'Тянитесь макушкой вверх, плечи при этом остаются опущенными и расслабленными.',
    titleEn: 'Neck stretch upward',
    descriptionEn:
        'Reach the crown of your head upward while keeping your shoulders down and relaxed.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'neck_04',
    categoryId: 'neck',
    type: HealthType.physical,
    title: 'Подбородок назад',
    description:
        'Мягко сдвиньте подбородок назад, удержите 2 секунды и отпустите.',
    titleEn: 'Chin tuck',
    descriptionEn:
        'Gently pull your chin back, hold for 2 seconds, and release.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'neck_05',
    categoryId: 'neck',
    type: HealthType.physical,
    title: 'Диагональное вытяжение шеи',
    description:
        'Наклоните ухо к плечу и направьте нос чуть вниз. Держите 15–20 секунд, затем смените сторону.',
    titleEn: 'Diagonal neck stretch',
    descriptionEn:
        'Tilt your ear toward your shoulder and point your nose slightly down. Hold for 15–20 seconds, then switch sides.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'neck_06',
    categoryId: 'neck',
    type: HealthType.physical,
    title: 'Полукруг подбородком',
    description:
        'Опустите подбородок к груди и медленно проведите от одной ключицы к другой.',
    titleEn: 'Chin half-circle',
    descriptionEn:
        'Drop your chin to your chest and slowly trace from one collarbone to the other.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'neck_07',
    categoryId: 'neck',
    type: HealthType.physical,
    title: 'Лоб в ладонь',
    description:
        'Упритесь лбом в ладонь и давите 5 секунд, не двигая шеей. Расслабьтесь и повторите.',
    titleEn: 'Forehead into palm',
    descriptionEn:
        'Press your forehead into your palm for 5 seconds without moving your neck. Relax and repeat.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'neck_08',
    categoryId: 'neck',
    type: HealthType.physical,
    title: 'Висок в ладонь',
    description:
        'Упритесь виском в ладонь и давите 5 секунд. Повторите и смените сторону.',
    titleEn: 'Temple into palm',
    descriptionEn:
        'Press your temple into your palm for 5 seconds. Repeat and switch sides.',
    defaultDurationSec: 40,
  ),

  // ── Плечи и руки ──────────────────────────────────────────────────────
  Exercise(
    id: 'shoulders_01',
    categoryId: 'shoulders_arms',
    type: HealthType.physical,
    title: 'Подъём и опускание плеч',
    description:
        'Медленно поднимайте плечи вверх, затем опускайте их вниз, расслабляя мышцы.',
    titleEn: 'Shoulder shrugs',
    descriptionEn:
        'Slowly raise your shoulders up, then lower them down, relaxing the muscles.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'shoulders_02',
    categoryId: 'shoulders_arms',
    type: HealthType.physical,
    title: 'Сведение лопаток сидя',
    description:
        'Сидя на стуле, медленно сведите лопатки вместе, затем расслабьтесь.',
    titleEn: 'Seated shoulder blade squeeze',
    descriptionEn:
        'While seated, slowly squeeze your shoulder blades together, then relax.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'arms_01',
    categoryId: 'shoulders_arms',
    type: HealthType.physical,
    title: 'Растяжка предплечий',
    description:
        'Вытяните руку вперёд и мягко тяните ладонь на себя, затем от себя.',
    titleEn: 'Forearm stretch',
    descriptionEn:
        'Extend your arm forward and gently pull your palm toward you, then away.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'shoulders_03',
    categoryId: 'shoulders_arms',
    type: HealthType.physical,
    title: 'Наружный разворот плеч',
    description:
        'Прижмите локти к корпусу и медленно разведите предплечья в стороны, затем верните обратно.',
    titleEn: 'External shoulder rotation',
    descriptionEn:
        'Keep your elbows at your sides and slowly rotate your forearms outward, then bring them back.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'shoulders_04',
    categoryId: 'shoulders_arms',
    type: HealthType.physical,
    title: 'Растяжка трицепса сидя',
    description:
        'Согните руку за головой, другой рукой мягко тяните локоть. Держите 15–20 секунд и смените сторону.',
    titleEn: 'Seated triceps stretch',
    descriptionEn:
        'Bend your arm behind your head and gently pull the elbow with the other hand. Hold for 15–20 seconds and switch.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'shoulders_05',
    categoryId: 'shoulders_arms',
    type: HealthType.physical,
    title: 'Рука через грудь',
    description:
        'Проведите руку перед грудью и другой рукой мягко прижмите к себе. Держите 15–20 секунд и смените сторону.',
    titleEn: 'Cross-body arm stretch',
    descriptionEn:
        'Bring your arm across your chest and gently press it with the other hand. Hold for 15–20 seconds and switch.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'shoulders_06',
    categoryId: 'shoulders_arms',
    type: HealthType.physical,
    title: 'Кисти за спиной',
    description:
        'Сведите кисти за спиной и мягко отведите локти назад, раскрывая грудную клетку.',
    titleEn: 'Hands behind back',
    descriptionEn:
        'Clasp your hands behind your back and gently pull your elbows back, opening your chest.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'shoulders_07',
    categoryId: 'shoulders_arms',
    type: HealthType.physical,
    title: 'Сгибание локтей вперёд',
    description:
        'Вытяните руки вперёд и медленно сгибайте локти, приближая кисти к плечам, затем выпрямляйте.',
    titleEn: 'Elbow curls',
    descriptionEn:
        'Extend your arms forward and slowly bend your elbows, bringing your hands to your shoulders, then straighten.',
    defaultDurationSec: 40,
  ),

  // ── Спина и поясница ──────────────────────────────────────────────────
  Exercise(
    id: 'back_01',
    categoryId: 'back_lower',
    type: HealthType.physical,
    title: 'Потягивание вверх сидя',
    description:
        'Сидя на стуле, поднимите руки вверх и мягко потянитесь всем телом.',
    titleEn: 'Seated overhead stretch',
    descriptionEn:
        'While seated, raise your arms overhead and gently stretch your whole body.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'back_02',
    categoryId: 'back_lower',
    type: HealthType.physical,
    title: 'Наклон корпуса вперёд',
    description:
        'С прямой спиной выполните лёгкий наклон корпуса вперёд, затем вернитесь назад.',
    titleEn: 'Forward body lean',
    descriptionEn:
        'With a straight back, gently lean your torso forward, then return to upright.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'back_03',
    categoryId: 'back_lower',
    type: HealthType.physical,
    title: 'Скручивание корпуса сидя',
    description:
        'Сидя на стуле, поверните корпус в сторону, держась за спинку стула.',
    titleEn: 'Seated torso twist',
    descriptionEn:
        'While seated, rotate your torso to one side, holding the back of the chair.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'back_04',
    categoryId: 'back_lower',
    type: HealthType.physical,
    title: 'Наклон таза сидя',
    description:
        'Сидя на краю стула, мягко перекатывайте таз вперёд и назад, меняя прогиб поясницы.',
    titleEn: 'Seated pelvic tilt',
    descriptionEn:
        'Sitting on the edge of the chair, gently rock your pelvis forward and back, changing the curve of your lower back.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'back_05',
    categoryId: 'back_lower',
    type: HealthType.physical,
    title: 'Грудной прогиб на стуле',
    description:
        'Ладони на затылок, локти в стороны. На вдохе мягко прогнитесь верхней частью спины.',
    titleEn: 'Seated thoracic extension',
    descriptionEn:
        'Hands behind your head, elbows wide. On inhale, gently arch your upper back.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'back_06',
    categoryId: 'back_lower',
    type: HealthType.physical,
    title: 'Боковое вытяжение корпуса',
    description:
        'Поднимите руку вверх и мягко наклонитесь в противоположную сторону. Держите 15–20 секунд и смените.',
    titleEn: 'Side body stretch',
    descriptionEn:
        'Raise one arm overhead and gently lean to the opposite side. Hold for 15–20 seconds and switch.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'back_07',
    categoryId: 'back_lower',
    type: HealthType.physical,
    title: 'Мягкая опора живота',
    description:
        'Ладони на рёбра и живот. Слегка напрягите мышцы корпуса на 3–4 секунды и расслабьтесь.',
    titleEn: 'Gentle core brace',
    descriptionEn:
        'Hands on your ribs and belly. Lightly brace your core for 3–4 seconds and relax.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'back_08',
    categoryId: 'back_lower',
    type: HealthType.physical,
    title: 'Колено к груди сидя',
    description:
        'Подтяните колено к груди руками под бедром. Держите 15–20 секунд и смените ногу.',
    titleEn: 'Seated knee to chest',
    descriptionEn:
        'Pull your knee to your chest with your hands under the thigh. Hold for 15–20 seconds and switch legs.',
    defaultDurationSec: 40,
  ),

  // ── Глаза ─────────────────────────────────────────────────────────────
  Exercise(
    id: 'eyes_01',
    categoryId: 'eyes',
    type: HealthType.physical,
    title: 'Осознанное моргание',
    description: 'Часто и мягко моргайте, полностью закрывая и открывая глаза.',
    titleEn: 'Mindful blinking',
    descriptionEn: 'Blink frequently and gently, fully closing and opening your eyes.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'eyes_02',
    categoryId: 'eyes',
    type: HealthType.physical,
    title: 'Мягкое закрытие глаз',
    description: 'Закройте глаза и расслабьте веки, не сжимая их.',
    titleEn: 'Gentle eye closing',
    descriptionEn: 'Close your eyes and relax your eyelids without squeezing them.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'eyes_03',
    categoryId: 'eyes',
    type: HealthType.physical,
    title: 'Зажмуривание и расслабление',
    description: 'Лёгко зажмурьте глаза, затем полностью расслабьте их.',
    titleEn: 'Squeeze and relax',
    descriptionEn: 'Gently squeeze your eyes shut, then fully relax them.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'eyes_04',
    categoryId: 'eyes',
    type: HealthType.physical,
    title: 'Движения глазами вверх и вниз',
    description: 'Медленно переводите взгляд вверх и вниз.',
    titleEn: 'Vertical eye movements',
    descriptionEn: 'Slowly move your gaze up and down.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'eyes_05',
    categoryId: 'eyes',
    type: HealthType.physical,
    title: 'Движения глазами вправо и влево',
    description: 'Медленно переводите взгляд вправо и влево.',
    titleEn: 'Horizontal eye movements',
    descriptionEn: 'Slowly move your gaze left and right.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'eyes_06',
    categoryId: 'eyes',
    type: HealthType.physical,
    title: 'Круговые движения глазами',
    description: 'Опишите взглядом круг по часовой стрелке и против неё.',
    titleEn: 'Eye circles',
    descriptionEn: 'Trace a circle with your gaze clockwise and then counterclockwise.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'eyes_07',
    categoryId: 'eyes',
    type: HealthType.physical,
    title: 'Даль-близь по пальцу',
    description:
        'Фокусируйтесь на пальце перед собой 3 секунды, затем на дальнем объекте 3 секунды.',
    titleEn: 'Near-far focus',
    descriptionEn:
        'Focus on your finger in front of you for 3 seconds, then on a distant object for 3 seconds.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'eyes_08',
    categoryId: 'eyes',
    type: HealthType.physical,
    title: 'Диагональные саккады',
    description:
        'Быстро переводите взгляд между двумя точками по диагонали, не двигая головой.',
    titleEn: 'Diagonal saccades',
    descriptionEn:
        'Quickly shift your gaze between two diagonal points without moving your head.',
    defaultDurationSec: 30,
  ),

  Exercise(
    id: 'eyes_09',
    categoryId: 'eyes',
    type: HealthType.physical,
    title: 'Восьмёрка взглядом',
    description:
        'Медленно проведите взглядом по контуру воображаемой горизонтальной восьмёрки.',
    titleEn: 'Figure-eight gaze',
    descriptionEn:
        'Slowly trace the outline of an imaginary horizontal figure eight with your eyes.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'eyes_10',
    categoryId: 'eyes',
    type: HealthType.physical,
    title: 'Сведение взгляда к пальцу',
    description:
        'Медленно приближайте палец от вытянутой руки к переносице, следя за ним глазами.',
    titleEn: 'Convergence with finger',
    descriptionEn:
        'Slowly bring your finger from arm\'s length toward your nose, tracking it with your eyes.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'eyes_11',
    categoryId: 'eyes',
    type: HealthType.physical,
    title: 'Расширение периферии',
    description:
        'Смотрите в одну точку и замечайте предметы по краям поля зрения, не двигая глазами.',
    titleEn: 'Peripheral awareness',
    descriptionEn:
        'Stare at one point and notice objects at the edges of your vision without moving your eyes.',
    defaultDurationSec: 40,
  ),

  // ── Кисти и запястья ───────────────────────────────────────────────────
  Exercise(
    id: 'wrist_01',
    categoryId: 'wrists_hands',
    type: HealthType.physical,
    title: 'Круги запястьями',
    description:
        'Медленно вращайте запястьями по кругу, затем смените направление.',
    titleEn: 'Wrist circles',
    descriptionEn:
        'Slowly rotate your wrists in circles, then switch direction.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'wrist_02',
    categoryId: 'wrists_hands',
    type: HealthType.physical,
    title: 'Скольжение сухожилий',
    description:
        'Чередуйте прямую ладонь, крючок пальцами и полный кулак медленно и плавно.',
    titleEn: 'Tendon glides',
    descriptionEn:
        'Alternate between a flat hand, hook fist, and full fist slowly and smoothly.',
    defaultDurationSec: 45,
  ),

  Exercise(
    id: 'wrist_03',
    categoryId: 'wrists_hands',
    type: HealthType.physical,
    title: 'Большой палец к пальцам',
    description:
        'По очереди касайтесь большим пальцем подушечек остальных пальцев.',
    titleEn: 'Thumb to fingers',
    descriptionEn:
        'Touch the tip of your thumb to each fingertip one at a time.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'wrist_04',
    categoryId: 'wrists_hands',
    type: HealthType.physical,
    title: 'Веер пальцами',
    description:
        'Широко разведите пальцы, затем мягко соберите их вместе. Повторяйте спокойно.',
    titleEn: 'Finger spread',
    descriptionEn:
        'Spread your fingers wide, then gently bring them together. Repeat calmly.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'wrist_05',
    categoryId: 'wrists_hands',
    type: HealthType.physical,
    title: 'Кисти вправо-влево',
    description:
        'Медленно отклоняйте кисти вправо и влево небольшими движениями.',
    titleEn: 'Side wrist bends',
    descriptionEn:
        'Slowly tilt your wrists to the right and left with small movements.',
    defaultDurationSec: 40,
  ),

  // ── Ноги и стопы ───────────────────────────────────────────────────────
  Exercise(
    id: 'feet_01',
    categoryId: 'legs_feet',
    type: HealthType.physical,
    title: 'Подъёмы на носки',
    description:
        'Поднимайте пятки, оставляя носки на полу. Задержитесь на секунду и опустите.',
    titleEn: 'Calf raises',
    descriptionEn:
        'Lift your heels while keeping your toes on the floor. Pause for a second and lower.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'feet_02',
    categoryId: 'legs_feet',
    type: HealthType.physical,
    title: 'Носки на себя',
    description:
        'Пятки на полу, поднимайте носки стоп вверх. Повторяйте ритмично.',
    titleEn: 'Toe raises',
    descriptionEn:
        'Keep your heels on the floor and lift your toes up. Repeat rhythmically.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'feet_03',
    categoryId: 'legs_feet',
    type: HealthType.physical,
    title: 'Круги стопами',
    description:
        'Поднимите стопу над полом и медленно вращайте в голеностопе. Смените направление или ногу.',
    titleEn: 'Ankle circles',
    descriptionEn:
        'Lift your foot off the floor and slowly rotate at the ankle. Switch direction or leg.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'feet_04',
    categoryId: 'legs_feet',
    type: HealthType.physical,
    title: 'Марш сидя',
    description:
        'Поочерёдно поднимайте колени на небольшую высоту, как при спокойном марше.',
    titleEn: 'Seated march',
    descriptionEn:
        'Alternately lift your knees slightly, as if marching in place while seated.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'feet_05',
    categoryId: 'legs_feet',
    type: HealthType.physical,
    title: 'Сжатие ягодиц сидя',
    description:
        'Напрягите ягодицы на 3 секунды и полностью расслабьте. Повторяйте.',
    titleEn: 'Seated glute squeeze',
    descriptionEn:
        'Squeeze your glutes for 3 seconds, then fully relax. Repeat.',
    defaultDurationSec: 40,
  ),

  // ── Осанка ─────────────────────────────────────────────────────────────
  Exercise(
    id: 'posture_01',
    categoryId: 'posture_alignment',
    type: HealthType.physical,
    title: 'Нейтральная посадка',
    description:
        'Сядьте на седалищные кости, стопы на полу, рёбра над тазом. Проверьте поясницу.',
    titleEn: 'Neutral sitting position',
    descriptionEn:
        'Sit on your sit bones, feet flat on the floor, ribs over your pelvis. Check your lower back.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'posture_02',
    categoryId: 'posture_alignment',
    type: HealthType.physical,
    title: 'Локти под плечами',
    description:
        'Предплечья на стол, локти под плечами. Расслабьте кисти и опустите плечи.',
    titleEn: 'Elbows under shoulders',
    descriptionEn:
        'Forearms on the desk, elbows under your shoulders. Relax your hands and lower your shoulders.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'posture_03',
    categoryId: 'posture_alignment',
    type: HealthType.physical,
    title: 'Рёбра над тазом',
    description:
        'Ладонь на рёбра, другую на таз. Выровняйте корпус так, чтобы рёбра не уходили вперёд.',
    titleEn: 'Ribs over pelvis',
    descriptionEn:
        'Place one hand on your ribs, the other on your pelvis. Align so your ribs don\'t jut forward.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'posture_04',
    categoryId: 'posture_alignment',
    type: HealthType.physical,
    title: 'Вес на седалищных костях',
    description:
        'Перенесите вес на правую седалищную кость, затем на левую. Найдите равновесие.',
    titleEn: 'Weight on sit bones',
    descriptionEn:
        'Shift your weight to the right sit bone, then to the left. Find your balance.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'posture_05',
    categoryId: 'posture_alignment',
    type: HealthType.physical,
    title: 'Дистанция до стола',
    description:
        'Сядьте так, чтобы локти лежали на столе без вытягивания плеч вперёд.',
    titleEn: 'Desk distance check',
    descriptionEn:
        'Sit so your elbows rest on the desk without reaching your shoulders forward.',
    defaultDurationSec: 40,
  ),

  // ── Снятие напряжения ─────────────────────────────────────────────────
  Exercise(
    id: 'relax_01',
    categoryId: 'relaxation',
    type: HealthType.mental,
    title: 'Медленное дыхание через нос',
    description:
        'Медленно вдыхайте через нос на 4–6 секунд, затем спокойно выдыхайте.',
    titleEn: 'Slow nasal breathing',
    descriptionEn:
        'Slowly inhale through your nose for 4–6 seconds, then exhale calmly.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'relax_02',
    categoryId: 'relaxation',
    type: HealthType.mental,
    title: 'Расслабление челюсти и плеч',
    description:
        'Осознанно расслабьте челюсть, затем опустите и расслабьте плечи.',
    titleEn: 'Jaw and shoulder release',
    descriptionEn:
        'Consciously relax your jaw, then drop and relax your shoulders.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'relax_03',
    categoryId: 'relaxation',
    type: HealthType.mental,
    title: 'Выдох с удлинением',
    description: 'Сделайте спокойный вдох и более длинный, медленный выдох.',
    titleEn: 'Extended exhale',
    descriptionEn: 'Take a calm inhale and a longer, slower exhale.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'relax_04',
    categoryId: 'relaxation',
    type: HealthType.mental,
    title: 'Сканирование кистей',
    description:
        'Перенесите внимание в ладони и предплечья. На выдохе отпускайте напряжение.',
    titleEn: 'Hand scan',
    descriptionEn:
        'Bring your attention to your palms and forearms. Release tension on each exhale.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'relax_05',
    categoryId: 'relaxation',
    type: HealthType.mental,
    title: 'Тёплые ладони',
    description:
        'Положите ладони на бёдра и сосредоточьтесь на ощущении тепла и контакта.',
    titleEn: 'Warm palms',
    descriptionEn:
        'Place your palms on your thighs and focus on the sensation of warmth and contact.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'relax_06',
    categoryId: 'relaxation',
    type: HealthType.mental,
    title: 'Опора спиной',
    description:
        'Почувствуйте контакт спины со спинкой стула. На выдохе позвольте корпусу расслабиться.',
    titleEn: 'Back support awareness',
    descriptionEn:
        'Feel the contact of your back against the chair. On exhale, let your body relax.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'relax_07',
    categoryId: 'relaxation',
    type: HealthType.mental,
    title: 'Мягкий взгляд вдаль',
    description:
        'Переведите взгляд с экрана на дальнюю точку и позвольте фокусу стать мягче.',
    titleEn: 'Soft gaze into distance',
    descriptionEn:
        'Shift your gaze from the screen to a distant point and let your focus soften.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'relax_08',
    categoryId: 'relaxation',
    type: HealthType.mental,
    title: 'Напряжение и отпускание',
    description:
        'Напрягите кисти, предплечья и плечи на 4 секунды, затем полностью отпустите.',
    titleEn: 'Tense and release',
    descriptionEn:
        'Tense your hands, forearms, and shoulders for 4 seconds, then fully release.',
    defaultDurationSec: 40,
  ),

  // ── Переключение внимания ─────────────────────────────────────────────
  Exercise(
    id: 'focus_01',
    categoryId: 'attention_switch',
    type: HealthType.mental,
    title: 'Фокус на внешнем звуке',
    description: 'Выберите один звук вокруг и удерживайте на нём внимание.',
    titleEn: 'Focus on an external sound',
    descriptionEn: 'Pick one sound around you and hold your attention on it.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'focus_02',
    categoryId: 'attention_switch',
    type: HealthType.mental,
    title: 'Отсчёт вдохов',
    description: 'Медленно отсчитайте 5 спокойных вдохов и выдохов.',
    titleEn: 'Counting breaths',
    descriptionEn: 'Slowly count 5 calm inhales and exhales.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'focus_03',
    categoryId: 'attention_switch',
    type: HealthType.mental,
    title: 'Ощущение опоры стоп',
    description: 'Сконцентрируйтесь на ощущении стоп, соприкасающихся с полом.',
    titleEn: 'Feeling your feet on the floor',
    descriptionEn: 'Focus on the sensation of your feet touching the floor.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'focus_04',
    categoryId: 'attention_switch',
    type: HealthType.mental,
    title: 'Пять предметов цвета',
    description:
        'Выберите цвет и найдите глазами пять предметов этого цвета вокруг.',
    titleEn: 'Five objects of one color',
    descriptionEn:
        'Pick a color and find five objects of that color around you.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'focus_05',
    categoryId: 'attention_switch',
    type: HealthType.mental,
    title: 'Обратный счёт тройками',
    description:
        'Начните с числа от 40 до 60 и считайте назад по три.',
    titleEn: 'Counting back by threes',
    descriptionEn:
        'Start from a number between 40 and 60 and count backward by three.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'focus_06',
    categoryId: 'attention_switch',
    type: HealthType.mental,
    title: 'Линии в комнате',
    description:
        'Найдите глазами три вертикальные и три горизонтальные линии вокруг.',
    titleEn: 'Lines in the room',
    descriptionEn:
        'Find three vertical and three horizontal lines around you.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'focus_07',
    categoryId: 'attention_switch',
    type: HealthType.mental,
    title: 'Один объект подробно',
    description:
        'Выберите предмет на столе и рассмотрите его форму, края, тени и текстуру.',
    titleEn: 'One object in detail',
    descriptionEn:
        'Pick an object on your desk and examine its shape, edges, shadows, and texture.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'focus_08',
    categoryId: 'attention_switch',
    type: HealthType.mental,
    title: 'Три формы вокруг',
    description:
        'Найдите вокруг один круглый, один прямоугольный и один неправильный предмет.',
    titleEn: 'Three shapes around you',
    descriptionEn:
        'Find one round, one rectangular, and one irregular-shaped object around you.',
    defaultDurationSec: 40,
  ),

  // ── Эмоциональная стабилизация ────────────────────────────────────────
  Exercise(
    id: 'emotion_01',
    categoryId: 'emotional_balance',
    type: HealthType.mental,
    title: 'Осознание текущего чувства',
    description: 'Мысленно задайте себе вопрос: «Что я сейчас чувствую?»',
    titleEn: 'Noticing your current feeling',
    descriptionEn: 'Mentally ask yourself: "What am I feeling right now?"',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'emotion_02',
    categoryId: 'emotional_balance',
    type: HealthType.mental,
    title: 'Нейтральная опорная мысль',
    description: 'Произнесите про себя короткую мысль: «Я здесь и сейчас».',
    titleEn: 'Neutral anchor thought',
    descriptionEn: 'Silently say to yourself: "I am here and now."',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'emotion_03',
    categoryId: 'emotional_balance',
    type: HealthType.mental,
    title: 'Визуализация завершённой задачи',
    description: 'Представьте, что текущая задача уже успешно завершена.',
    titleEn: 'Visualizing a completed task',
    descriptionEn: 'Imagine that your current task has already been successfully completed.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'emotion_04',
    categoryId: 'emotional_balance',
    type: HealthType.mental,
    title: 'Факт и оценка',
    description:
        'Назовите факт ситуации, затем отдельно — свою оценку или мысль о нём.',
    titleEn: 'Fact vs. judgment',
    descriptionEn:
        'Name a fact about the situation, then separately state your opinion or thought about it.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'emotion_05',
    categoryId: 'emotional_balance',
    type: HealthType.mental,
    title: 'Шкала интенсивности',
    description:
        'Оцените эмоцию от 0 до 10 и назовите действие, чтобы снизить её на пункт.',
    titleEn: 'Intensity scale',
    descriptionEn:
        'Rate your emotion from 0 to 10 and name one action to lower it by one point.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'emotion_06',
    categoryId: 'emotional_balance',
    type: HealthType.mental,
    title: 'Потребность за эмоцией',
    description:
        'Спросите себя, о чём сигнализирует эмоция: отдых, ясность, помощь или время.',
    titleEn: 'Need behind the emotion',
    descriptionEn:
        'Ask yourself what the emotion signals: rest, clarity, help, or time.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'emotion_07',
    categoryId: 'emotional_balance',
    type: HealthType.mental,
    title: 'Пауза перед ответом',
    description:
        'Перед ответом сделайте спокойный вдох и выдох. Сформулируйте ответ про себя.',
    titleEn: 'Pause before responding',
    descriptionEn:
        'Before responding, take a calm inhale and exhale. Formulate your answer silently.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'emotion_08',
    categoryId: 'emotional_balance',
    type: HealthType.mental,
    title: 'Две версии объяснения',
    description:
        'Назовите первую мысль о ситуации, затем придумайте более нейтральное объяснение.',
    titleEn: 'Two explanations',
    descriptionEn:
        'Name your first thought about the situation, then come up with a more neutral explanation.',
    defaultDurationSec: 40,
  ),

  // ── Дыхание ────────────────────────────────────────────────────────────
  Exercise(
    id: 'breath_01',
    categoryId: 'breathing',
    type: HealthType.mental,
    title: 'Квадратное дыхание',
    description:
        'Вдох 4 сек, пауза 4 сек, выдох 4 сек, пауза 4 сек. Повторите 2–3 цикла.',
    titleEn: 'Box breathing',
    descriptionEn:
        'Inhale 4 sec, hold 4 sec, exhale 4 sec, hold 4 sec. Repeat 2–3 cycles.',
    defaultDurationSec: 60,
  ),

  Exercise(
    id: 'breath_02',
    categoryId: 'breathing',
    type: HealthType.mental,
    title: 'Дыхание 4-2-6',
    description:
        'Вдох 4 сек, пауза 2 сек, выдох 6 сек. Выполняйте мягко и спокойно.',
    titleEn: '4-2-6 breathing',
    descriptionEn:
        'Inhale 4 sec, hold 2 sec, exhale 6 sec. Perform gently and calmly.',
    defaultDurationSec: 60,
  ),

  Exercise(
    id: 'breath_03',
    categoryId: 'breathing',
    type: HealthType.mental,
    title: 'Рёберное дыхание',
    description:
        'Ладони на нижние рёбра. На вдохе почувствуйте расширение, на выдохе — возврат.',
    titleEn: 'Rib breathing',
    descriptionEn:
        'Hands on your lower ribs. On inhale, feel them expand; on exhale, feel them return.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'breath_04',
    categoryId: 'breathing',
    type: HealthType.mental,
    title: 'Дыхание животом',
    description:
        'Ладонь на живот. Дышите так, чтобы на вдохе она поднималась, на выдохе опускалась.',
    titleEn: 'Belly breathing',
    descriptionEn:
        'Hand on your belly. Breathe so it rises on inhale and falls on exhale.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'breath_05',
    categoryId: 'breathing',
    type: HealthType.mental,
    title: 'Физиологический вздох',
    description:
        'Короткий вдох, затем второй довдох и длинный расслабленный выдох. Повторите 3–5 раз.',
    titleEn: 'Physiological sigh',
    descriptionEn:
        'A short inhale, then a second top-up inhale, followed by a long relaxed exhale. Repeat 3–5 times.',
    defaultDurationSec: 40,
  ),

  // ── Когнитивная разгрузка ──────────────────────────────────────────────
  Exercise(
    id: 'unload_01',
    categoryId: 'cognitive_unload',
    type: HealthType.mental,
    title: 'Три открытые задачи',
    description:
        'Назовите три задачи в голове и пометьте каждую: срочно, позже или не сейчас.',
    titleEn: 'Three open tasks',
    descriptionEn:
        'Name three tasks on your mind and label each: urgent, later, or not now.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'unload_02',
    categoryId: 'cognitive_unload',
    type: HealthType.mental,
    title: 'Следующее малое действие',
    description:
        'Выберите одну задачу и назовите один конкретный ближайший шаг.',
    titleEn: 'Next small action',
    descriptionEn:
        'Pick one task and name one specific next step.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'unload_03',
    categoryId: 'cognitive_unload',
    type: HealthType.mental,
    title: 'Закрытие петли',
    description:
        'Вспомните повторяющуюся мысль и решите: выполнить, записать, делегировать или отпустить.',
    titleEn: 'Closing the loop',
    descriptionEn:
        'Recall a recurring thought and decide: do it, write it down, delegate, or let it go.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'unload_04',
    categoryId: 'cognitive_unload',
    type: HealthType.mental,
    title: 'Ментальная полка',
    description:
        'Мысленно отложите задачу на полку и назовите время, когда вернётесь к ней.',
    titleEn: 'Mental shelf',
    descriptionEn:
        'Mentally place the task on a shelf and name the time you\'ll come back to it.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'unload_05',
    categoryId: 'cognitive_unload',
    type: HealthType.mental,
    title: 'Один фокус',
    description:
        'Выберите одно дело на ближайшие минуты и скажите себе: «Сейчас только это».',
    titleEn: 'Single focus',
    descriptionEn:
        'Choose one thing for the next few minutes and tell yourself: "Only this, right now."',
    defaultDurationSec: 40,
  ),
];

final exerciseRepository = ExerciseRepository(
  categories: exerciseCategories,
  exercises: exercises,
);
