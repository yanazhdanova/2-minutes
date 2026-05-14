import '../domain/exercise_models.dart';
import 'exercise_repository.dart';

/// Каталог категорий упражнений.
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
        'Положите ладонь на лоб. Мягко давите лбом в ладонь, удерживая голову на месте 5 секунд.',
    titleEn: 'Forehead into palm',
    descriptionEn:
        'Place your palm on your forehead. Gently press into it, keeping your head still for 5 seconds.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'neck_08',
    categoryId: 'neck',
    type: HealthType.physical,
    title: 'Висок в ладонь',
    description:
        'Положите ладонь на висок. Мягко давите головой в ладонь 5 секунд, затем смените сторону.',
    titleEn: 'Temple into palm',
    descriptionEn:
        'Place your palm on your temple. Gently press your head into it for 5 seconds, then switch sides.',
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
        'Сядьте прямо, плечи опущены. Мягко отведите локти назад, сведите лопатки и расслабьтесь.',
    titleEn: 'Seated shoulder blade squeeze',
    descriptionEn:
        'Sit tall with shoulders down. Gently move your elbows back, squeeze your shoulder blades, and relax.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'arms_01',
    categoryId: 'shoulders_arms',
    type: HealthType.physical,
    title: 'Растяжка предплечий',
    description:
        'Вытяните руку вперёд. Другой рукой мягко потяните пальцы на себя, затем ладонь вниз.',
    titleEn: 'Forearm stretch',
    descriptionEn:
        'Extend one arm. With the other hand, gently pull your fingers toward you, then press the palm down.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'shoulders_03',
    categoryId: 'shoulders_arms',
    type: HealthType.physical,
    title: 'Наружный разворот плеч',
    description:
        'Согните локти под 90 градусов и прижмите к бокам. Разведите предплечья наружу и верните обратно.',
    titleEn: 'External shoulder rotation',
    descriptionEn:
        'Bend your elbows to 90 degrees and keep them at your sides. Rotate your forearms outward and back.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'shoulders_04',
    categoryId: 'shoulders_arms',
    type: HealthType.physical,
    title: 'Растяжка трицепса сидя',
    description:
        'Поднимите руку и согните её за головой. Другой рукой мягко потяните локоть и смените сторону.',
    titleEn: 'Seated triceps stretch',
    descriptionEn:
        'Raise one arm and bend it behind your head. Gently pull the elbow with the other hand, then switch.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'shoulders_05',
    categoryId: 'shoulders_arms',
    type: HealthType.physical,
    title: 'Рука через грудь',
    description:
        'Вытяните руку перед грудью в сторону. Другой рукой мягко прижмите её к себе и смените сторону.',
    titleEn: 'Cross-body arm stretch',
    descriptionEn:
        'Bring one arm across your chest. Gently press it closer with the other hand, then switch sides.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'shoulders_06',
    categoryId: 'shoulders_arms',
    type: HealthType.physical,
    title: 'Кисти за спиной',
    description:
        'Соедините руки за спиной в замок. Мягко отведите плечи назад и раскройте грудную клетку.',
    titleEn: 'Hands behind back',
    descriptionEn:
        'Clasp your hands behind your back. Gently move your shoulders back and open your chest.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'shoulders_07',
    categoryId: 'shoulders_arms',
    type: HealthType.physical,
    title: 'Сгибание локтей вперёд',
    description:
        'Вытяните руки перед собой ладонями вверх. Медленно сгибайте локти к плечам и выпрямляйте.',
    titleEn: 'Elbow curls',
    descriptionEn:
        'Extend your arms forward, palms up. Slowly bend your elbows toward your shoulders, then straighten.',
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
        'Сядьте на край стула, стопы на полу. С прямой спиной мягко наклонитесь вперёд и вернитесь.',
    titleEn: 'Forward body lean',
    descriptionEn:
        'Sit on the edge of the chair with feet on the floor. Keep your back straight, lean forward gently, then return.',
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
        'Сядьте на край стула. Слегка прогните поясницу и подайте таз вперёд, затем округлите назад.',
    titleEn: 'Seated pelvic tilt',
    descriptionEn:
        'Sit on the edge of the chair. Slightly arch your lower back and tilt your pelvis forward, then round back.',
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
    id: 'back_08',
    categoryId: 'back_lower',
    type: HealthType.physical,
    title: 'Колено к груди сидя',
    description:
        'Сядьте прямо. Возьмитесь руками под бедром и мягко подтяните колено к груди, затем смените ногу.',
    titleEn: 'Seated knee to chest',
    descriptionEn:
        'Sit tall. Hold under your thigh and gently pull one knee toward your chest, then switch legs.',
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
    descriptionEn:
        'Blink frequently and gently, fully closing and opening your eyes.',
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
    descriptionEn:
        'Trace a circle with your gaze clockwise and then counterclockwise.',
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
    title: 'Взгляд по диагонали',
    description:
        'Переводите взгляд из верхнего правого угла в нижний левый, затем наоборот. Голова неподвижна.',
    titleEn: 'Diagonal eye movements',
    descriptionEn:
        'Move your gaze from upper right to lower left, then the other way. Keep your head still.',
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
    title: 'Ладонь, крючок, кулак',
    description:
        'Распрямите ладонь, согните пальцы крючком, затем сожмите кулак. Повторяйте плавно.',
    titleEn: 'Palm, hook, fist',
    descriptionEn:
        'Open your palm, bend your fingers into a hook, then make a fist. Repeat smoothly.',
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

  Exercise(
    id: 'wrist_06',
    categoryId: 'wrists_hands',
    type: HealthType.physical,
    title: 'Стряхивание кистей',
    description:
        'Опустите руки вниз и мягко встряхните кистями, будто снимаете лишнее напряжение.',
    titleEn: 'Hand shakeout',
    descriptionEn:
        'Lower your arms and gently shake your hands, as if releasing extra tension.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'wrist_07',
    categoryId: 'wrists_hands',
    type: HealthType.physical,
    title: 'Кулак и раскрытие',
    description:
        'Сожмите кисти в мягкий кулак, затем широко раскройте ладони и пальцы.',
    titleEn: 'Fist and open hand',
    descriptionEn: 'Make a soft fist, then open your palms and fingers wide.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'wrist_08',
    categoryId: 'wrists_hands',
    type: HealthType.physical,
    title: 'Растяжка большого пальца',
    description:
        'Мягко отведите большой палец в сторону другой рукой, задержитесь и смените руку.',
    titleEn: 'Thumb stretch',
    descriptionEn:
        'Gently pull your thumb to the side with the other hand, hold, then switch hands.',
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
    title: 'Пятка-носок',
    description:
        'Поочерёдно ставьте стопу на пятку, затем на носок. Повторяйте спокойно каждой ногой.',
    titleEn: 'Heel-to-toe',
    descriptionEn:
        'Alternate placing your foot on the heel, then on the toes. Repeat calmly with each foot.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'feet_06',
    categoryId: 'legs_feet',
    type: HealthType.physical,
    title: 'Сжимание пальцев стоп',
    description:
        'Поставьте стопы на пол. Мягко сожмите пальцы стоп, затем полностью расслабьте.',
    titleEn: 'Toe curls',
    descriptionEn:
        'Place your feet on the floor. Gently curl your toes, then fully relax them.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'feet_07',
    categoryId: 'legs_feet',
    type: HealthType.physical,
    title: 'Перекат стопы',
    description:
        'Перекатывайте стопу с пятки на носок и обратно, не отрывая ногу далеко от пола.',
    titleEn: 'Foot roll',
    descriptionEn:
        'Roll your foot from heel to toes and back, keeping it close to the floor.',
    defaultDurationSec: 40,
  ),

  // ── Осанка ─────────────────────────────────────────────────────────────
  Exercise(
    id: 'posture_01',
    categoryId: 'posture_alignment',
    type: HealthType.physical,
    title: 'Положение за столом',
    description:
        'Сядьте прямо: стопы на полу, спина вытянута, экран перед глазами. Сделайте 3 спокойных вдоха.',
    titleEn: 'Desk position check',
    descriptionEn:
        'Sit upright: feet on the floor, back tall, screen in front of your eyes. Take 3 calm breaths.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'posture_02',
    categoryId: 'posture_alignment',
    type: HealthType.physical,
    title: 'Опора за столом',
    description:
        'Поставьте стопы на пол, предплечья положите на стол. Опустите плечи и выровняйте спину.',
    titleEn: 'Desk support',
    descriptionEn:
        'Place your feet on the floor and forearms on the desk. Lower your shoulders and straighten your back.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'posture_03',
    categoryId: 'posture_alignment',
    type: HealthType.physical,
    title: 'Плечи назад и вниз',
    description:
        'Мягко отведите плечи назад, затем опустите их вниз. Не прогибайтесь в пояснице.',
    titleEn: 'Shoulders back and down',
    descriptionEn:
        'Gently move your shoulders back, then lower them down. Do not arch your lower back.',
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
        'Выберите число от 40 до 60 и отнимайте по 3, пока не закончится время.',
    titleEn: 'Counting back by threes',
    descriptionEn:
        'Choose a number from 40 to 60 and subtract 3 until the time is over.',
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
    descriptionEn: 'Find three vertical and three horizontal lines around you.',
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
        'Найдите вокруг три предмета разной формы: круглый, прямоугольный и любой другой.',
    titleEn: 'Three shapes around you',
    descriptionEn:
        'Find three objects of different shapes around you: round, rectangular, and any other shape.',
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
    title: 'Я здесь и сейчас',
    description: 'Произнесите про себя короткую мысль: «Я здесь и сейчас».',
    titleEn: 'Here and now',
    descriptionEn: 'Silently say to yourself: "I am here and now."',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'emotion_03',
    categoryId: 'emotional_balance',
    type: HealthType.mental,
    title: 'Назвать чувство',
    description:
        'Назовите про себя одно чувство, которое есть сейчас: усталость, тревога, злость, спокойствие или другое.',
    titleEn: 'Name the feeling',
    descriptionEn:
        'Silently name one feeling that is present now: tiredness, anxiety, anger, calm, or another.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'emotion_04',
    categoryId: 'emotional_balance',
    type: HealthType.mental,
    title: 'Одно действие для себя',
    description:
        'Выберите одно простое действие, чтобы улучшить состояние: выдохнуть, встать или выпить воды.',
    titleEn: 'One helpful action',
    descriptionEn:
        'Choose one simple action to feel better: exhale, stand up, or drink water.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'emotion_05',
    categoryId: 'emotional_balance',
    type: HealthType.mental,
    title: 'Оценка напряжения',
    description:
        'Оцените своё напряжение от 0 до 10. Сделайте один спокойный выдох и снизьте оценку на пункт.',
    titleEn: 'Tension check',
    descriptionEn:
        'Rate your tension from 0 to 10. Take one calm exhale and lower the score by one point.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'emotion_06',
    categoryId: 'emotional_balance',
    type: HealthType.mental,
    title: 'Три спокойных факта',
    description:
        'Назовите три нейтральных факта вокруг: где вы сидите, какой сейчас свет, что лежит рядом.',
    titleEn: 'Three calm facts',
    descriptionEn:
        'Name three neutral facts around you: where you are sitting, what the light is like, what is nearby.',
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
    title: 'Двойной вдох и длинный выдох',
    description:
        'Короткий вдох, затем второй довдох и длинный расслабленный выдох. Повторите 3–5 раз.',
    titleEn: 'Double inhale and long exhale',
    descriptionEn:
        'A short inhale, then a second top-up inhale, followed by a long relaxed exhale. Repeat 3–5 times.',
    defaultDurationSec: 40,
  ),

  Exercise(
    id: 'breath_06',
    categoryId: 'breathing',
    type: HealthType.mental,
    title: 'Выдох через рот',
    description:
        'Вдохните через нос, затем медленно выдохните через рот, как будто дуете на горячий чай.',
    titleEn: 'Exhale through the mouth',
    descriptionEn:
        'Inhale through your nose, then slowly exhale through your mouth as if cooling hot tea.',
    defaultDurationSec: 40,
  ),
];

final exerciseRepository = ExerciseRepository(
  categories: exerciseCategories,
  exercises: exercises,
);
