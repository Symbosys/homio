import 'overview/ai_overview_page.dart';

import 'room_designer/room_designer_page.dart';

import 'vastu/vastu_page.dart';

import 'budget_calculator/budget_calculator_page.dart';

import 'doubt_solver/doubt_solver_page.dart';
import 'designer_consultation/designer_consultation_page.dart';

// Interim placeholder exports until all tool pages are created
export 'models/models.dart';
export 'overview/ai_overview_page.dart';
export 'room_designer/room_designer_page.dart';
export 'image_generator/image_generator_page.dart';
export 'video_generator/video_generator_page.dart';
export 'material_specification/material_specification_page.dart';
export 'vastu/vastu_page.dart';
export 'budget_calculator/budget_calculator_page.dart';
export 'doubt_solver/doubt_solver_page.dart';
export 'designer_consultation/designer_consultation_page.dart';
export 'history_saved/saved_designs_page.dart';
export 'history_saved/ai_history_page.dart';
export 'credits/ai_credits_page.dart';

typedef ClientAiStudioHubPage = AiOverviewPage;
typedef ClientAiRoomGeneratorPage = RoomDesignerPage;
typedef ClientAiVastuConsultantPage = VastuPage;
typedef ClientAiBudgetEstimatorPage = BudgetCalculatorPage;
typedef ClientAiDoubtSolverPage = DoubtSolverPage;
typedef ClientDesignerConsultationPage = DesignerConsultationPage;
