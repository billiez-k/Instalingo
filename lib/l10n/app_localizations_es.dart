// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get achievementsTitle => 'Logros';

  @override
  String get active => 'Activo';

  @override
  String get advancedProgressTracking => 'Seguimiento de progreso avanzado';

  @override
  String get aiAssistantName => 'Maya';

  @override
  String get aiAssistantRole => 'Trabajadora de cafetería';

  @override
  String get aiBadge => 'IA';

  @override
  String get aiChat => 'Chat con IA';

  @override
  String get aiConversationGreeting =>
      '¡Hola! Soy Maya. Trabajo en una cafetería en Tokio. ¿Qué te gustaría practicar hoy?';

  @override
  String get aiConversationPractice => 'Práctica de conversación con IA';

  @override
  String get aiConversationTitle => 'Conversación con IA';

  @override
  String get aiPractice => 'Práctica con IA';

  @override
  String get aiYou => 'Tú';

  @override
  String get annual => 'Anual';

  @override
  String get appTagline => 'Aprende. Relájate. Repite.';

  @override
  String get appTitle => 'InstaLingo';

  @override
  String get back => 'Atrás';

  @override
  String get cancel => 'Cancelar';

  @override
  String get chapter => 'Capítulo';

  @override
  String get chatWithAI => 'Chatear con un personaje de IA';

  @override
  String get check => 'Comprobar';

  @override
  String get chill => 'Relajarse';

  @override
  String get chillCorner => 'Rincón de relax';

  @override
  String get chill_addComment => 'Añadir un comentario...';

  @override
  String get chill_aiGeneratedImage => 'Imagen generada por IA';

  @override
  String get chill_comments => 'Comentarios';

  @override
  String get chill_noPosts => 'Aún no hay publicaciones';

  @override
  String get chill_noPostsMessage =>
      'Completa lecciones para desbloquear publicaciones de vocabulario de la comunidad.';

  @override
  String get chill_postNotFound => 'Publicación no encontrada';

  @override
  String get chill_postNotFoundMessage =>
      'Esta publicación puede haber sido eliminada o ya no está disponible.';

  @override
  String get chill_share => 'Compartir';

  @override
  String get clear => 'Limpiar';

  @override
  String get clearAll => 'Limpiar todo';

  @override
  String get commitment => 'Compromiso';

  @override
  String get continueLearning => 'Continuar aprendiendo';

  @override
  String get continueText => 'Continuar';

  @override
  String get correct => 'Correcto';

  @override
  String correctCountOfTotal(int correct, int total) {
    return '$correct / $total correctos';
  }

  @override
  String correctWithExplanation(String explanation) {
    return '¡Correcto! $explanation';
  }

  @override
  String get courseComplete => '¡Curso completado!';

  @override
  String get courseCompleteTitle => '¡Lo lograste!';

  @override
  String get coursePath => 'Ruta del curso';

  @override
  String get createProfile => 'Crea tu perfil';

  @override
  String get createProfileDesc =>
      'Esto nos ayuda a personalizar tu experiencia.';

  @override
  String get dailyGoal => 'Meta diaria';

  @override
  String get dailyGoalCardTitle => 'Meta diaria';

  @override
  String get dailyGoalReached => '¡Meta alcanzada! ¡Gran trabajo!';

  @override
  String get darkMode => 'Modo oscuro';

  @override
  String get dayStreak => 'Racha de días';

  @override
  String dayStreakCount(int count) {
    return '$count días';
  }

  @override
  String get defaultDisplayName => 'Estudiante';

  @override
  String get done => 'Listo';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get emptyStateMessage => 'Vuelve más tarde para más contenido.';

  @override
  String get emptyStateTitle => 'Aún no hay nada aquí';

  @override
  String get errorGenericMessage =>
      'No pudimos cargar este contenido. Por favor, inténtalo de nuevo.';

  @override
  String get errorGenericTitle => 'Algo salió mal';

  @override
  String get exArrangeWords =>
      'Ordena las palabras para formar una oración correcta';

  @override
  String get exComprehension => 'Lee el texto y responde';

  @override
  String get exDialogueComplete => 'Completa el diálogo';

  @override
  String get exFillInBlank => 'Rellena el espacio en blanco';

  @override
  String get exFlashCard => 'Toca para voltear la tarjeta';

  @override
  String get exGrammarTip => 'Consejo de gramática';

  @override
  String get exImageIdentify => 'Toca la imagen correcta';

  @override
  String get exMatchWords => 'Relaciona las palabras con sus significados';

  @override
  String get exPhraseBuilder => 'Construye la frase';

  @override
  String get exSpeaking => 'Di esta palabra en voz alta';

  @override
  String get exTranslate => 'Traduce esta oración';

  @override
  String get exTrueFalse => '¿Es correcta esta afirmación?';

  @override
  String get exTypeWhatYouHear => 'Escribe lo que escuchas';

  @override
  String exVocabMultipleChoice(Object word) {
    return '¿Qué significa \"$word\"?';
  }

  @override
  String exWhichWordMeans(Object word) {
    return '¿Qué significa \"$word\"?';
  }

  @override
  String get exWriting => 'Escribe tu respuesta';

  @override
  String get exampleLabel => 'Ejemplo';

  @override
  String exercisesProgress(int completed, int total) {
    return '$completed de $total ejercicios';
  }

  @override
  String get falseLabel => 'Falso';

  @override
  String get featureAICharacters => 'Personajes de IA';

  @override
  String get featureAICharactersDesc =>
      'Practica con personajes de IA que responden como personas reales en el Chill Corner.';

  @override
  String get featureMotivation => 'Mantente Motivado';

  @override
  String get featureMotivationDesc =>
      'Gana XP, mantén rachas y desbloquea logros a medida que progresas.';

  @override
  String get featureStructuredCourses => 'Cursos Estructurados';

  @override
  String get featureStructuredCoursesDesc =>
      'Aprende con lecciones diseñadas profesionalmente que se construyen una sobre otra.';

  @override
  String get findFriends => 'Buscar amigos';

  @override
  String get finishLesson => 'Terminar lección';

  @override
  String get flashcardEasy => 'Fácil';

  @override
  String get flashcardGood => 'Bien';

  @override
  String get flashcardHard => 'Difícil';

  @override
  String get followingTitle => 'Siguiendo';

  @override
  String get forceUpdateBody =>
      'Hemos hecho InstaLingo más rápido, estable y con nuevas funciones. Actualiza a la última versión para continuar.';

  @override
  String get forceUpdateBugFixes => 'Corrección de errores y estabilidad';

  @override
  String get forceUpdateMessage =>
      'Hay una nueva versión de InstaLingo disponible. Actualiza para seguir aprendiendo.';

  @override
  String get forceUpdateNewContent => 'Nuevas lecciones y ejercicios';

  @override
  String get forceUpdatePerformance => 'Mejoras de rendimiento';

  @override
  String get forceUpdateTitle => 'Actualización requerida';

  @override
  String get fri => 'V';

  @override
  String get friendsTitle => 'Amigos';

  @override
  String get gems => 'Gemas';

  @override
  String get getStarted => 'Empezar';

  @override
  String get getUnlimitedLearning => 'Obtener aprendizaje ilimitado';

  @override
  String get goodbye => 'Adiós';

  @override
  String get gotIt => '¡Entendido!';

  @override
  String get grammarExampleFallback => '¡La práctica hace al maestro!';

  @override
  String get grammarRuleFallback =>
      'Presta atención a la gramática en este ejercicio.';

  @override
  String get grammarTip => 'Consejo de gramática';

  @override
  String get greetingAfternoon => 'Buenas tardes';

  @override
  String get greetingEvening => 'Buenas noches';

  @override
  String get greetingMorning => 'Buenos días';

  @override
  String get hello => '¡Hola!';

  @override
  String get helpSupport => 'Ayuda y soporte';

  @override
  String get holdToSpeak => 'Mantén para hablar';

  @override
  String get howAreYou => '¿Cómo estás?';

  @override
  String get iAlreadyHaveAccount => 'Ya tengo una cuenta';

  @override
  String get incorrect => 'Incorrecto';

  @override
  String get knowIt => 'Lo sé';

  @override
  String get language => 'Idioma';

  @override
  String get leaderboardTitle => 'Clasificación';

  @override
  String get learn => 'Aprender';

  @override
  String get learnRuleToImprove => 'Aprende esta regla para mejorar';

  @override
  String get learningLanguage => 'Idioma a aprender';

  @override
  String get lessonComplete => '¡Lección completada!';

  @override
  String get lessonCompleteGood =>
      '¡Buen esfuerzo! ¡Repasa y vuelve a intentarlo!';

  @override
  String get lessonCompleteGreat => '¡Buen trabajo! ¡Sigue practicando!';

  @override
  String get lessonCompletePerfect => '¡Perfecto! ¡Estás que ardes!';

  @override
  String get lessons => 'Lecciones';

  @override
  String get levelAbbreviation => 'NV';

  @override
  String get levelAdvanced => 'Avanzado';

  @override
  String get levelBeginner => 'Principiante';

  @override
  String get levelElementary => 'Elemental';

  @override
  String get levelIntermediate => 'Intermedio';

  @override
  String get levelProficiency => 'Dominio';

  @override
  String get levelUpperIntermediate => 'Intermedio Alto';

  @override
  String get loading => 'Cargando...';

  @override
  String get loadingLesson => 'Cargando lección...';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get matchPairsInstruction =>
      'Toca una palabra a la izquierda, luego su correspondencia a la derecha';

  @override
  String get maybeLater => 'Quizás después';

  @override
  String get mon => 'L';

  @override
  String get monthly => 'Mensual';

  @override
  String get motivation => 'Motivación';

  @override
  String get myNameIs => 'Me llamo';

  @override
  String get nativeLanguage => 'Idioma nativo';

  @override
  String get next => 'Siguiente';

  @override
  String get nextQuestion => 'Siguiente pregunta';

  @override
  String get niceToMeetYou => 'Mucho gusto';

  @override
  String get noAds => 'Sin anuncios';

  @override
  String get noConnectionMessage =>
      'Por favor, comprueba tu conexión a internet e inténtalo de nuevo.';

  @override
  String get noConnectionTitle => 'Sin conexión';

  @override
  String get notNow => 'Ahora no';

  @override
  String notQuiteWithExplanation(String explanation) {
    return 'No exactamente. $explanation';
  }

  @override
  String get notifications => 'Notificaciones';

  @override
  String get onboardingTitle =>
      'Aprende idiomas con cursos estructurados y personajes de IA';

  @override
  String get onboarding_commitmentCasual => 'Informal';

  @override
  String get onboarding_commitmentIntense => 'Intenso';

  @override
  String get onboarding_commitmentRegular => 'Habitual';

  @override
  String get onboarding_commitmentSerious => 'Serio';

  @override
  String get onboarding_commitmentSubtitle =>
      'Siempre puedes cambiar esto más tarde en la configuración.';

  @override
  String get onboarding_commitmentTitle => '¿Cuánto tiempo\npuedes dedicar?';

  @override
  String get onboarding_displayNameLabel => 'Nombre de visualización';

  @override
  String get onboarding_emailOptionalLabel => 'Correo (opcional)';

  @override
  String get onboarding_enterEmailHint => 'Ingresa tu correo';

  @override
  String get onboarding_enterNameHint => 'Ingresa tu nombre';

  @override
  String get onboarding_learningLangSubtitle =>
      'Elige el idioma que quieres dominar.';

  @override
  String get onboarding_motivationBrainTraining => 'Entrenamiento cerebral';

  @override
  String get onboarding_motivationCareer => 'Carrera';

  @override
  String get onboarding_motivationCulture => 'Cultura';

  @override
  String get onboarding_motivationFamily => 'Familia';

  @override
  String get onboarding_motivationFun => 'Solo por diversión';

  @override
  String get onboarding_motivationMoviesShows => 'Películas y series';

  @override
  String get onboarding_motivationStudyAbroad => 'Estudiar en el extranjero';

  @override
  String get onboarding_motivationSubtitle =>
      'Selecciona todas las que apliquen.';

  @override
  String get onboarding_motivationTitle => '¿Por qué estás aprendiendo?';

  @override
  String get onboarding_motivationTravel => 'Viajes';

  @override
  String get onboarding_nativeLangSubtitle =>
      'Usaremos esto para personalizar tu experiencia de aprendizaje.';

  @override
  String get onboarding_proficiencyAdvanced => 'Avanzado';

  @override
  String get onboarding_proficiencyAdvancedDesc => 'Hablo con fluidez';

  @override
  String get onboarding_proficiencyBeginner => 'Principiante';

  @override
  String get onboarding_proficiencyBeginnerDesc => 'Sé algunas palabras';

  @override
  String get onboarding_proficiencyElementary => 'Elemental';

  @override
  String get onboarding_proficiencyElementaryDesc =>
      'Puedo formar oraciones simples';

  @override
  String get onboarding_proficiencyIntermediate => 'Intermedio';

  @override
  String get onboarding_proficiencyIntermediateDesc =>
      'Puedo mantener una conversación';

  @override
  String get onboarding_proficiencyProficient => 'Competente';

  @override
  String get onboarding_proficiencyProficientDesc => 'Hablo como un nativo';

  @override
  String get onboarding_proficiencySubtitle =>
      'Te iniciaremos en la dificultad adecuada.';

  @override
  String get onboarding_proficiencyTitle => '¿Cuál es tu\nnivel actual?';

  @override
  String get onboarding_proficiencyUpperIntermediate => 'Intermedio-Alto';

  @override
  String get onboarding_proficiencyUpperIntermediateDesc =>
      'Puedo discutir varios temas';

  @override
  String get onboarding_skipForNow => 'Saltar por ahora';

  @override
  String get paywallSubtitle => 'Desbloquea el aprendizaje ilimitado';

  @override
  String get paywallTitle => 'InstaLingo Super';

  @override
  String get perMonth => '/mes';

  @override
  String get perYear => '/año';

  @override
  String get pickNewCourse => 'Elegir nuevo curso';

  @override
  String get playing => 'Reproduciendo...';

  @override
  String get practiceWords => 'Practicar las palabras que acabas de aprender';

  @override
  String get privacy => 'Privacidad';

  @override
  String get proficiency => 'Nivel';

  @override
  String get profile => 'Perfil';

  @override
  String get profile_academicEnglish => 'Inglés académico';

  @override
  String get profile_account => 'Cuenta';

  @override
  String get profile_achievementsUnlocked => 'Logros desbloqueados';

  @override
  String get profile_adFreeExperience => 'Experiencia sin anuncios';

  @override
  String get profile_adFreeExperienceDesc =>
      'Concéntrate en aprender sin interrupciones.';

  @override
  String get profile_advanced => 'Avanzado';

  @override
  String get profile_advancedSpeakingDesc =>
      'Obtén análisis detallado de pronunciación y fluidez con forma de onda';

  @override
  String get profile_advancedSpeakingFeedback =>
      'Retroalimentación avanzada de habla';

  @override
  String get profile_aiConversationPractice => 'Práctica de conversación IA';

  @override
  String get profile_aiConversationPracticeAnswer =>
      'Practica conversaciones reales con personajes de IA en diferentes escenarios';

  @override
  String get profile_allChillCornerContent =>
      'Todo el contenido de Chill Corner';

  @override
  String get profile_appearance => 'Apariencia';

  @override
  String get profile_beginner => 'Principiante';

  @override
  String get profile_bestValue => 'Mejor valor';

  @override
  String get profile_browseTopics =>
      'Explora los temas a continuación o contáctanos directamente';

  @override
  String get profile_businessEnglish => 'Inglés de negocios';

  @override
  String get profile_cancelAnytime => 'Cancela cuando quieras. Sin compromiso.';

  @override
  String get profile_checkForUpdates => 'Buscar actualizaciones';

  @override
  String get profile_completeBeginner => 'Principiante total';

  @override
  String get profile_contactSupport => 'Contactar soporte';

  @override
  String get profile_createPlan => 'Crear plan';

  @override
  String get profile_dailyConversation => 'Conversación diaria';

  @override
  String get profile_daytime => 'De día (9 AM-5 PM)';

  @override
  String get profile_displayName => 'Nombre para mostrar';

  @override
  String get profile_duration => 'Duración';

  @override
  String get profile_durationDesc => '¿Cuánto tiempo por sesión?';

  @override
  String get profile_earningXPGems => 'Ganar XP y gemas';

  @override
  String get profile_earningXPGemsAnswer =>
      'Completa lecciones, mantén rachas y repasa vocabulario para ganar XP y gemas.';

  @override
  String get profile_elementary => 'Elemental';

  @override
  String get profile_email => 'Correo electrónico';

  @override
  String get profile_enableNotifications => 'Activar notificaciones';

  @override
  String get profile_enableNotificationsAnswer =>
      'Activa los recordatorios en Configuración para recibir avisos diarios y mantener tu racha.';

  @override
  String get profile_enterYourEmail => 'Ingresa tu correo';

  @override
  String get profile_enterYourName => 'Ingresa tu nombre';

  @override
  String get profile_evening => 'Tarde (5 PM-9 PM)';

  @override
  String get profile_everyDay => 'Todos los días';

  @override
  String get profile_everythingInMonthly => 'Todo en el plan mensual';

  @override
  String get profile_examPreparation => 'Preparación de exámenes';

  @override
  String get profile_exclusiveStudyPlans => 'Planes de estudio exclusivos';

  @override
  String get profile_fifteenMinutes => '15 minutos';

  @override
  String get profile_fiveDaysAWeek => '5 días a la semana';

  @override
  String get profile_fiveMinutes => '5 minutos';

  @override
  String get profile_follow => 'Seguir';

  @override
  String get profile_followOthersMessage =>
      'Sigue a otros estudiantes para verlos aquí.';

  @override
  String get profile_gettingStarted => 'Primeros pasos';

  @override
  String get profile_goal => 'Objetivo';

  @override
  String get profile_goalDesc => '¿Qué quieres lograr?';

  @override
  String get profile_gotIt => 'Entendido';

  @override
  String get profile_howDoIStart => '¿Cómo empiezo a aprender?';

  @override
  String get profile_howDoIStartAnswer =>
      'Elige tu idioma nativo y luego selecciona un idioma para aprender.';

  @override
  String get profile_inProgress => 'En progreso';

  @override
  String get profile_instalingoSuperFAQ => 'InstaLingo Super';

  @override
  String get profile_instalingoSuperFAQAnswer =>
      'Actualiza a Super para lecciones ilimitadas, práctica con IA y estadísticas avanzadas.';

  @override
  String get profile_intensity => 'Intensidad';

  @override
  String get profile_intensityDesc => '¿Con qué frecuencia por semana?';

  @override
  String get profile_intermediate => 'Intermedio';

  @override
  String get profile_learning => 'Aprendizaje';

  @override
  String get profile_learningFeatures => 'Funciones de aprendizaje';

  @override
  String profile_learningStatus(String language, String level) {
    return 'Aprendiendo: $language · $level';
  }

  @override
  String get profile_lessonRemindersStreakAlerts =>
      'Recordatorios de lecciones y alertas de racha';

  @override
  String profile_lessonsCompleted(int completed, int total) {
    return '$completed de $total lecciones completadas';
  }

  @override
  String get profile_level => 'Nivel';

  @override
  String get profile_levelDesc => '¿Desde dónde comienzas?';

  @override
  String get profile_levelSuffix => 'nivel';

  @override
  String profile_minPerDay(int min) {
    return '$min min/día';
  }

  @override
  String profile_minutesCount(int count) {
    return '$count minutos/día';
  }

  @override
  String get profile_morning => 'Mañana (6-9 AM)';

  @override
  String get profile_night => 'Noche (9 PM-12 AM)';

  @override
  String get profile_noAchievementsMessage =>
      'Completa lecciones y mantén rachas para desbloquear logros';

  @override
  String get profile_noAchievementsYet => 'Aún no hay logros';

  @override
  String get profile_notSet => 'No configurado';

  @override
  String get profile_offlineMode => 'Modo sin conexión';

  @override
  String get profile_offlineModeDesc =>
      'Descarga todas las lecciones y contenido';

  @override
  String get profile_perMonthDesc => 'por mes';

  @override
  String get profile_perYearDesc => 'por año';

  @override
  String get profile_personalizedStudyPlans =>
      'Planes de estudio personalizados';

  @override
  String get profile_personalizedStudyPlansDesc =>
      'Planes generados por IA adaptados a tus objetivos y horario';

  @override
  String get profile_priorityAIResponses => 'Respuestas de IA prioritarias';

  @override
  String get profile_proBadge => 'PRO';

  @override
  String get profile_proficiencyLevel => 'Nivel de competencia';

  @override
  String get profile_proficient => 'Competente';

  @override
  String get profile_resetProgress => 'Restablecer progreso';

  @override
  String get profile_resetProgressFAQ => 'Restablecer progreso';

  @override
  String get profile_resetProgressFAQAnswer =>
      'Ve a Configuración > Restablecer progreso para empezar de nuevo. Esta acción no se puede deshacer.';

  @override
  String get profile_saveFiftyVsMonthly => 'Ahorra 50% vs mensual';

  @override
  String get profile_schedule => 'Horario';

  @override
  String get profile_scheduleDesc => '¿Cuándo puedes estudiar?';

  @override
  String get profile_settingDailyGoals => 'Establecer metas diarias';

  @override
  String get profile_settingDailyGoalsAnswer =>
      'Ve a Perfil > Configuración > Meta diaria para ajustar tu tiempo de aprendizaje.';

  @override
  String get profile_someBasics => 'Algunos conocimientos básicos';

  @override
  String get profile_soundEffects => 'Efectos de sonido';

  @override
  String profile_stepXofY(int current, int total) {
    return 'Paso $current/$total';
  }

  @override
  String profile_streakLabel(int count) {
    return '$count días de racha';
  }

  @override
  String get profile_studyPlanCreated => '¡Plan de estudio creado con éxito!';

  @override
  String get profile_superBadge => 'SUPER';

  @override
  String get profile_superSubtitle =>
      'La experiencia definitiva de aprendizaje de idiomas con funciones de IA';

  @override
  String get profile_superTitle => 'InstaLingo Super';

  @override
  String get profile_tenMinutes => '10 minutos';

  @override
  String get profile_threeDaysAWeek => '3 días a la semana';

  @override
  String get profile_travelBasics => 'Conceptos básicos de viaje';

  @override
  String get profile_twentyPlusMinutes => '20+ minutos';

  @override
  String get profile_unlimitedAIConversations => 'Conversaciones IA ilimitadas';

  @override
  String get profile_unlimitedAIDesc =>
      'Practica con personajes de IA sin límites en Chill Corner';

  @override
  String get profile_unlockFullExperience => 'Desbloquear experiencia completa';

  @override
  String get profile_unlocked => 'Desbloqueado';

  @override
  String get profile_upgradeToSuper => 'Actualizar a Super';

  @override
  String get profile_upperIntermediate => 'Intermedio alto';

  @override
  String profile_version(String version) {
    return 'InstaLingo v$version';
  }

  @override
  String get profile_visitHelpCenter => 'Visitar centro de ayuda';

  @override
  String get profile_weekendsOnly => 'Solo fines de semana';

  @override
  String get profile_whatIsChillCorner => '¿Qué es Chill Corner?';

  @override
  String get profile_whatIsChillCornerAnswer =>
      'Chill Corner muestra el vocabulario que has aprendido en contenido generado por IA en contextos reales.';

  @override
  String questionXofY(int current, int total) {
    return 'Pregunta $current de $total';
  }

  @override
  String get readyToLearn => '¿Listo para aprender hoy?';

  @override
  String get reminderTime => '9:00 a. m.';

  @override
  String get review => 'Repasar';

  @override
  String get reviewVocabulary => 'Repasar vocabulario';

  @override
  String get sampleAnswer => 'Respuesta de ejemplo:';

  @override
  String get sat => 'S';

  @override
  String get save => 'Guardar';

  @override
  String savePercent(int percent) {
    return 'Ahorra $percent%';
  }

  @override
  String get scenarioCafeTokyo =>
      'Escenario: Ordenar en una cafetería en Tokio';

  @override
  String get section => 'Sección';

  @override
  String get sections => 'Secciones';

  @override
  String get seeResults => 'Ver resultados';

  @override
  String get seeWordsInContext => 'Ver tus palabras aprendidas en contexto';

  @override
  String get settingsTitle => 'Configuración';

  @override
  String get skip => 'Saltar';

  @override
  String speakersCount(String speakers) {
    return '$speakers hablantes';
  }

  @override
  String get start => 'Empezar';

  @override
  String get startFreeTrial => 'Iniciar prueba gratis';

  @override
  String get startLearning => 'Comenzar a aprender';

  @override
  String get startNextLesson => 'Empezar la siguiente lección del curso';

  @override
  String get statsTitle => 'Estadísticas';

  @override
  String get stillLearning => 'Todavía aprendiendo';

  @override
  String get streakCalendar => 'Calendario de racha';

  @override
  String streakKeepStreak(int currentStreak) {
    return '¡Completa una lección para mantener tu racha de $currentStreak días!';
  }

  @override
  String get streakRepair => 'Reparar Racha';

  @override
  String get streakRepaired => 'Reparado';

  @override
  String get streakShielded => 'Protegido';

  @override
  String streakShieldsRemaining(int count) {
    return '$count escudos de racha restantes';
  }

  @override
  String get studyPlan => 'Plan de estudio';

  @override
  String get submit => 'Enviar';

  @override
  String get subscription => 'Suscripción';

  @override
  String get sun => 'D';

  @override
  String get takePlacementTest => 'Hacer prueba de nivel';

  @override
  String get tapAndHoldMicrophone =>
      'Mantén presionado el micrófono para hablar';

  @override
  String get tapToFlip => 'Toca para voltear';

  @override
  String get tapToFlipBack => 'Toca para voltear';

  @override
  String get tapToPlay => 'Toca para reproducir';

  @override
  String get tapToReveal => 'Toca para revelar';

  @override
  String get tapWordsToBuildAnswer =>
      'Toca las palabras para construir tu respuesta';

  @override
  String get tapWordsToBuildSentence =>
      'Toca las palabras para construir la oración';

  @override
  String get thu => 'J';

  @override
  String timeAgoHours(int hours) {
    return 'Hace $hours horas';
  }

  @override
  String timeAgoMinutes(int minutes) {
    return 'Hace $minutes minutos';
  }

  @override
  String get timeSpent => 'Tiempo dedicado';

  @override
  String timeSpentHoursMinutes(int hours, int minutes) {
    return '$hours horas $minutes minutos';
  }

  @override
  String get today => 'Hoy';

  @override
  String get totalXP => 'XP total';

  @override
  String get trueLabel => 'Verdadero';

  @override
  String get tryAgain => 'Intentar de nuevo';

  @override
  String get tue => 'M';

  @override
  String get typeMessage => 'Escribe un mensaje...';

  @override
  String get typeWhatYouHear => 'Escribe lo que escuchas...';

  @override
  String get typeYourAnswerHere => 'Escribe tu respuesta aquí...';

  @override
  String get unlimitedLessons => 'Lecciones ilimitadas';

  @override
  String get unlockSuper => 'Desbloquear Super';

  @override
  String get updateNow => 'Actualizar ahora';

  @override
  String get visitChillCorner => 'Visitar Chill Corner';

  @override
  String get vocabularyReview => 'Repaso de vocabulario';

  @override
  String get wed => 'M';

  @override
  String get welcomeSubtitle =>
      'La forma más efectiva de aprender un nuevo idioma.';

  @override
  String get welcomeTitle => 'Bienvenido a InstaLingo';

  @override
  String get whatNext => '¿Qué te gustaría hacer ahora?';

  @override
  String get wordsLearned => 'Palabras aprendidas';

  @override
  String get wordsPracticed => 'Palabras practicadas';

  @override
  String get xpShort => 'XP';

  @override
  String get xpThisWeek => 'XP esta semana';

  @override
  String xpToGoal(int xp) {
    return '$xp XP';
  }

  @override
  String get youLabel => 'Tú';

  @override
  String get yourLevel => 'Tu nivel';

  @override
  String get profile_chooseYourPlan => 'Elige tu plan';

  @override
  String get profile_contactUs => 'Contáctanos';

  @override
  String get profile_continueWithFree => 'Continuar con gratis';

  @override
  String get profile_culturalInsights => 'Perspectivas culturales';

  @override
  String get profile_culturalInsightsDesc =>
      'Aprende el contexto cultural y el uso de cada palabra';

  @override
  String get profile_currentPlan => 'Plan actual';

  @override
  String get profile_dailyGoalMet => '¡Objetivo diario alcanzado!';

  @override
  String get profile_darkMode => 'Modo oscuro';

  @override
  String get profile_downloadForOffline => 'Descargar para usar sin conexión';

  @override
  String get profile_downloadForOfflineDesc =>
      'Aprende en cualquier momento y lugar, sin internet';

  @override
  String get profile_emailUs => 'Envíanos un correo';

  @override
  String get profile_falseBeginner => 'Falso principiante';

  @override
  String get profile_faq => 'Preguntas frecuentes';

  @override
  String get profile_faqAnswer1 =>
      'InstaLingo es una aplicación inmersiva para aprender idiomas a través de escenarios del mundo real.';

  @override
  String get profile_faqAnswer2 =>
      'Puedes actualizar al plan Super en cualquier momento.';

  @override
  String get profile_faqAnswer3 =>
      'Puedes restablecer tu progreso en Configuración > Restablecer progreso.';

  @override
  String get profile_faqAnswer4 =>
      'Puedes contactar a nuestro equipo de soporte en Configuración > Contactar soporte.';

  @override
  String get profile_faqQuestion1 => '¿Qué es InstaLingo?';

  @override
  String get profile_faqQuestion2 => '¿Puedo actualizar más tarde?';

  @override
  String get profile_faqQuestion3 => '¿Cómo restablezco mi progreso?';

  @override
  String get profile_faqQuestion4 => '¿Cómo contacto al soporte?';

  @override
  String get profile_feedback => 'Comentarios';

  @override
  String get profile_findFriends => 'Encontrar amigos';

  @override
  String get profile_firstSteps => 'Primeros pasos';

  @override
  String get profile_followingTitle => 'Siguiendo';

  @override
  String get profile_freePlan => 'Gratis';

  @override
  String get profile_goPremium => 'Actualizar a Premium';

  @override
  String get profile_goalDescription =>
      '¿Cuál es tu principal objetivo de aprendizaje?';

  @override
  String get profile_goalFluency => 'Fluidez';

  @override
  String get profile_goalTravel => 'Viajes';

  @override
  String get profile_goalWork => 'Trabajo';

  @override
  String get profile_inTheMorning => 'Por la mañana';

  @override
  String get profile_keepPracticing => '¡Sigue practicando!';

  @override
  String get profile_lateNight => 'Noche (después de las 9 PM)';

  @override
  String get profile_leaderboardTitle => 'Clasificación';

  @override
  String get profile_learnBasicPhrases => 'Aprender frases básicas';

  @override
  String get profile_levelUp => '¡Subiste de nivel!';

  @override
  String get profile_monthly => 'Mensual';

  @override
  String get profile_morningBird => 'Madrugador (5 AM-9 AM)';

  @override
  String get profile_mostPopular => 'Más popular';

  @override
  String get profile_motivationCulture => 'Cultura';

  @override
  String get profile_motivationFamily => 'Familia';

  @override
  String get profile_motivationFun => 'Diversión';

  @override
  String get profile_motivationTravel => 'Viajes';

  @override
  String get profile_motivationWork => 'Trabajo';

  @override
  String get profile_myPlan => 'Mi plan';

  @override
  String get profile_nextAchievement => 'Próximo logro';

  @override
  String get profile_noFollowingYet => 'Aún no sigues a nadie';

  @override
  String get profile_noFollowingYetMessage =>
      '¡Sigue a otros estudiantes para mantenerte al día!';

  @override
  String get profile_noFriendsYet => 'Aún no tienes amigos';

  @override
  String get profile_noFriendsYetMessage =>
      '¡Conéctate con otros estudiantes y practiquen juntos!';

  @override
  String get profile_noLeaderboardData => 'Aún no hay datos de clasificación';

  @override
  String get profile_noLeaderboardDataMessage =>
      '¡Comienza a aprender para aparecer en la clasificación!';

  @override
  String get profile_notifications => 'Notificaciones';

  @override
  String get profile_offlineTitle => 'Sin conexión';

  @override
  String get profile_onboardingComplete => 'Integración completada';

  @override
  String get profile_onboardingTitle => 'Integración';

  @override
  String get profile_perMonth => '/mes';

  @override
  String get profile_plan => 'Plan';

  @override
  String get profile_premium => 'Premium';

  @override
  String get profile_proFeatures => 'Funciones Pro';

  @override
  String get profile_proFeaturesDesc =>
      'Desbloquea todo el contenido y funciones premium';

  @override
  String get profile_proPlan => 'Plan Pro';

  @override
  String get profile_proPlanDesc =>
      'Acelera tu aprendizaje con funciones premium';

  @override
  String get profile_profile => 'Perfil';

  @override
  String get profile_progress => 'Progreso';

  @override
  String get profile_progressReset => 'Se restablecerá el progreso';

  @override
  String get profile_progressResetMessage =>
      'Esto eliminará todo tu progreso. Esta acción no se puede deshacer.';

  @override
  String profile_questionXofY(Object x, Object y) {
    return 'Pregunta $x/$y';
  }

  @override
  String get profile_reminder => 'Recordatorio';

  @override
  String get profile_reminderTime => 'Hora de recordatorio';

  @override
  String get profile_removeAds => 'Eliminar anuncios';

  @override
  String get profile_removeAdsDesc =>
      'Disfruta de una experiencia sin interrupciones';

  @override
  String profile_savePercent(Object percent) {
    return 'Ahorra $percent%';
  }

  @override
  String get profile_section => 'Sección';

  @override
  String get profile_seeAll => 'Ver todo';

  @override
  String get profile_sendFeedback => 'Enviar comentarios';

  @override
  String get profile_skillLevel => 'Nivel de habilidad';

  @override
  String get profile_speakingPractice => 'Práctica de conversación';

  @override
  String get profile_startFreeTrial => 'Comenzar prueba gratuita';

  @override
  String get profile_studyPlanDescription => 'Personaliza tu plan de estudio.';

  @override
  String get profile_studyPlanTitle => 'Plan de estudio';

  @override
  String get profile_studyReminder => 'Recordatorio de estudio';

  @override
  String get profile_subscribeNow => 'Suscribirse ahora';

  @override
  String get profile_subtitle => 'Perfil';

  @override
  String get profile_superDescription => 'Desbloquea todas las funciones Super';

  @override
  String get profile_support => 'Soporte';

  @override
  String get profile_travelPhrases => 'Frases de viaje';

  @override
  String get profile_troubleshooting => 'Solución de problemas';

  @override
  String profile_tryFreeForDays(Object days, Object price) {
    return 'Prueba gratis por $days días, luego $price';
  }

  @override
  String get profile_unlimitedAccess => 'Acceso ilimitado';

  @override
  String get profile_unlimitedAccessDesc =>
      'Accede a todos los cursos de idiomas y lecciones';

  @override
  String get profile_unlimitedAiConversations => 'Conversaciones IA ilimitadas';

  @override
  String get profile_unlimitedAiConversationsDesc =>
      'Practica conversaciones con tutores de IA en cualquier momento';

  @override
  String get profile_unlimitedLessons => 'Lecciones ilimitadas';

  @override
  String get profile_unlimitedLessonsDesc =>
      'Accede a todas las lecciones sin restricciones';

  @override
  String get profile_unlimitedVocabularyBuilder =>
      'Constructor de vocabulario ilimitado';

  @override
  String get profile_unlimitedVocabularyBuilderDesc =>
      'Amplía tu vocabulario con tarjetas adaptativas';

  @override
  String get profile_weekdays => 'Días laborables';

  @override
  String get profile_weekends => 'Fines de semana';

  @override
  String get profile_whenToStudy => '¿Cuándo estudiarás?';

  @override
  String get profile_workCommunication => 'Comunicación laboral';

  @override
  String get profile_workVocabulary => 'Vocabulario de negocios';

  @override
  String get profile_writingPractice => 'Práctica de escritura';

  @override
  String get profile_xpAndGems => 'XP y gemas';

  @override
  String get profile_xpAndGemsDesc => 'Gana XP y gemas completando lecciones';

  @override
  String get profile_xpEarnedToday => 'XP ganado hoy';

  @override
  String get profile_youEarned => '¡Has ganado!';

  @override
  String get profile_yourStreak => 'Tu racha';

  @override
  String get progressToNextLevel => 'Progreso al siguiente nivel';

  @override
  String get rateApp => 'Calificar aplicación';

  @override
  String get recording => 'Grabando...';

  @override
  String get removeAds => 'Eliminar anuncios';

  @override
  String get saveAndContinue => 'Guardar y continuar';

  @override
  String get searchPosts => 'Buscar publicaciones';

  @override
  String sectionX(Object x) {
    return 'Sección $x';
  }

  @override
  String get seeAllAchievements => 'Ver todos los logros';

  @override
  String get shareApp => 'Compartir aplicación';

  @override
  String get speakNow => 'Habla ahora';

  @override
  String get startSpeaking => 'Comenzar a hablar';

  @override
  String get streakTitle => 'Racha';

  @override
  String get studyNow => 'Estudiar ahora';

  @override
  String get subscribeNow => 'Suscribirse ahora';

  @override
  String get superMarket => 'Súper Mercado';

  @override
  String get swipeToContinue => 'Desliza para continuar';

  @override
  String get tapToListen => 'Toca para escuchar';

  @override
  String get tapToSpeak => 'Toca para hablar';

  @override
  String get technicalIssues => 'Problemas técnicos';

  @override
  String get totalLessons => 'Total de lecciones';

  @override
  String get unlimited => 'Ilimitado';

  @override
  String get unlockAllFeatures => 'Desbloquear todas las funciones';

  @override
  String get unlockNow => 'Desbloquear ahora';

  @override
  String get upgradeToPro => 'Actualizar a Pro';

  @override
  String get upgradeToSuper => 'Actualizar a Super';

  @override
  String get viewAll => 'Ver todo';

  @override
  String get viewDetails => 'Ver detalles';

  @override
  String get viewLeaderboard => 'Ver clasificación';

  @override
  String get vocabulary => 'Vocabulario';

  @override
  String get weekly => 'Semanal';

  @override
  String get weeklyGoal => 'Objetivo semanal';

  @override
  String get welcome => 'Bienvenido';

  @override
  String get welcomeBack => 'Bienvenido de nuevo';

  @override
  String get wordOfTheDay => 'Palabra del día';

  @override
  String get xpEarned => 'XP ganado';

  @override
  String get yearly => 'Anual';

  @override
  String get yes => 'Sí';

  @override
  String get youAreOffline => 'Estás sin conexión';

  @override
  String get yourAnswer => 'Tu respuesta';

  @override
  String get yourProgress => 'Tu progreso';

  @override
  String get onboarding_learningGoalTitle => '¿Cuál es tu objetivo?';

  @override
  String get onboarding_learningGoalSubtitle =>
      'Esto nos ayuda a personalizar tu experiencia de aprendizaje.';

  @override
  String get onboarding_examPrep => 'Prepararse para un examen';

  @override
  String get onboarding_examPrepDesc =>
      'Lecciones estructuradas, exámenes de prueba, práctica cronometrada. Sigue tu puntuación estimada.';

  @override
  String get onboarding_justForFun => 'Solo por diversión';

  @override
  String get onboarding_justForFunDesc =>
      'Aprende a tu ritmo. Sin exámenes, sin presión. Simplemente adquiere el idioma de forma natural.';

  @override
  String get onboarding_examTypeTitle => '¿Qué examen?';

  @override
  String onboarding_examTypeSubtitle(String lang) {
    return 'Elige el examen de $lang para el que te estás preparando.';
  }

  @override
  String get onboarding_japanese => 'japonés';

  @override
  String get onboarding_korean => 'coreano';

  @override
  String get onboarding_examLevelBeginner => 'Principiante';

  @override
  String get onboarding_examLevelElementary => 'Elemental';

  @override
  String get onboarding_examLevelBeginnerElementary => 'Principiante–Elemental';

  @override
  String onboarding_examWordsCount(String count) {
    return '$count palabras';
  }

  @override
  String get onboarding_examSectionsJLPT =>
      'Vocabulario, Gramática, Lectura, Comprensión oral';

  @override
  String get onboarding_examSectionsTOPIK => 'Comprensión oral, Lectura';

  @override
  String get keepPracticing => '¡Sigue practicando!';

  @override
  String get kanjiReference => 'Referencia Kanji';

  @override
  String get kanaReference => 'Tablas Kana';

  @override
  String get hiraganaChart => 'Hiragana';

  @override
  String get katakanaChart => 'Katakana';

  @override
  String get examCompleteTitle => '¡Examen de prueba completado!';

  @override
  String get yourScore => 'Tu puntuación';

  @override
  String get predictedLevel => 'Nivel estimado';

  @override
  String get profile_tts => 'Pronunciación (TTS)';

  @override
  String get profile_ttsDesc => 'Toca palabras para escuchar la pronunciación';

  @override
  String get studyReminderBody => '¡Hora de practicar!';

  @override
  String get jlptN5Label => 'JLPT N5';

  @override
  String get jlptN4Label => 'JLPT N4';

  @override
  String get onboarding_examLevelIntermediate => 'Intermedio';

  @override
  String get onboarding_examLevelUpperIntermediate => 'Intermedio alto';

  @override
  String get onboarding_examLevelAdvanced => 'Avanzado';
}
