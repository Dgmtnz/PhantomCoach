import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:phantom_coach/config/app_config.dart';
import 'package:phantom_coach/models/workout_model.dart';
import 'package:phantom_coach/models/nutrition_model.dart';
import 'package:phantom_coach/models/user_model.dart';

class SheetsService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: AppConfig.googleSheetsScopes,
  );
  
  sheets.SheetsApi? _sheetsApi;
  drive.DriveApi? _driveApi;
  
  // Initialize APIs
  Future<void> init() async {
    try {
      // Get authentication client
      final HttpClient? client = await _googleSignIn.authenticatedClient();
      
      if (client == null) {
        throw Exception('Failed to authenticate with Google');
      }
      
      // Initialize APIs
      _sheetsApi = sheets.SheetsApi(client);
      _driveApi = drive.DriveApi(client);
    } catch (e) {
      throw Exception('Failed to initialize Sheets API: ${e.toString()}');
    }
  }
  
  // Check if authenticated
  Future<bool> isAuthenticated() async {
    return _googleSignIn.isSignedIn();
  }
  
  // Authenticate with Google
  Future<void> authenticate() async {
    try {
      await _googleSignIn.signIn();
      await init();
    } catch (e) {
      throw Exception('Google authentication failed: ${e.toString()}');
    }
  }
  
  // Create a new spreadsheet
  Future<String> createSpreadsheet(String title) async {
    try {
      if (_sheetsApi == null) {
        await init();
      }
      
      final spreadsheet = sheets.Spreadsheet(
        properties: sheets.SpreadsheetProperties(
          title: title,
        ),
      );
      
      final response = await _sheetsApi!.spreadsheets.create(spreadsheet);
      return response.spreadsheetId!;
    } catch (e) {
      throw Exception('Failed to create spreadsheet: ${e.toString()}');
    }
  }
  
  // Get spreadsheet by ID
  Future<sheets.Spreadsheet> getSpreadsheet(String spreadsheetId) async {
    try {
      if (_sheetsApi == null) {
        await init();
      }
      
      return await _sheetsApi!.spreadsheets.get(spreadsheetId);
    } catch (e) {
      throw Exception('Failed to get spreadsheet: ${e.toString()}');
    }
  }
  
  // Create workout tracking spreadsheet
  Future<String> setupWorkoutTrackingSpreadsheet(User user) async {
    try {
      if (_sheetsApi == null) {
        await init();
      }
      
      // Create the spreadsheet
      final spreadsheetId = await createSpreadsheet('Workout Tracking - ${user.displayName}');
      
      // Create sheets for different tracking purposes
      final requests = [
        sheets.Request(
          addSheet: sheets.AddSheetRequest(
            properties: sheets.SheetProperties(
              title: 'Routines',
              gridProperties: sheets.GridProperties(
                rowCount: 1000,
                columnCount: 10,
              ),
            ),
          ),
        ),
        sheets.Request(
          addSheet: sheets.AddSheetRequest(
            properties: sheets.SheetProperties(
              title: 'Workouts',
              gridProperties: sheets.GridProperties(
                rowCount: 1000,
                columnCount: 10,
              ),
            ),
          ),
        ),
        sheets.Request(
          addSheet: sheets.AddSheetRequest(
            properties: sheets.SheetProperties(
              title: 'Exercises',
              gridProperties: sheets.GridProperties(
                rowCount: 1000,
                columnCount: 10,
              ),
            ),
          ),
        ),
      ];
      
      // Execute the batch update to create sheets
      await _sheetsApi!.spreadsheets.batchUpdate(
        sheets.BatchUpdateSpreadsheetRequest(requests: requests),
        spreadsheetId,
      );
      
      // Add headers to Routines sheet
      await _sheetsApi!.spreadsheets.values.update(
        sheets.ValueRange(
          values: [
            [
              'ID',
              'Name',
              'Description',
              'Category',
              'Difficulty',
              'Created At',
              'Last Used',
              'Exercise Count',
              'Duration (min)',
              'Notes',
            ],
          ],
        ),
        spreadsheetId,
        'Routines!A1:J1',
        valueInputOption: 'USER_ENTERED',
      );
      
      // Add headers to Workouts sheet
      await _sheetsApi!.spreadsheets.values.update(
        sheets.ValueRange(
          values: [
            [
              'ID',
              'Routine ID',
              'Date',
              'Start Time',
              'End Time',
              'Duration (min)',
              'Total Weight Lifted (kg)',
              'Calories Burned',
              'Notes',
              'Completed Exercises',
            ],
          ],
        ),
        spreadsheetId,
        'Workouts!A1:J1',
        valueInputOption: 'USER_ENTERED',
      );
      
      // Add headers to Exercises sheet
      await _sheetsApi!.spreadsheets.values.update(
        sheets.ValueRange(
          values: [
            [
              'ID',
              'Name',
              'Category',
              'Muscle Groups',
              'Equipment',
              'Is Compound',
              'Description',
              'Rest Between Sets',
              'Image URL',
              'Video URL',
            ],
          ],
        ),
        spreadsheetId,
        'Exercises!A1:J1',
        valueInputOption: 'USER_ENTERED',
      );
      
      // Format headers (make bold, freeze)
      final formatRequests = [
        sheets.Request(
          repeatCell: sheets.RepeatCellRequest(
            range: sheets.GridRange(
              sheetId: 0,
              startRowIndex: 0,
              endRowIndex: 1,
              startColumnIndex: 0,
              endColumnIndex: 10,
            ),
            cell: sheets.CellData(
              userEnteredFormat: sheets.CellFormat(
                textFormat: sheets.TextFormat(
                  bold: true,
                ),
                backgroundColor: sheets.Color(
                  red: 0.9,
                  green: 0.9,
                  blue: 0.9,
                ),
              ),
            ),
            fields: 'userEnteredFormat(textFormat,backgroundColor)',
          ),
        ),
        sheets.Request(
          updateSheetProperties: sheets.UpdateSheetPropertiesRequest(
            properties: sheets.SheetProperties(
              sheetId: 0,
              gridProperties: sheets.GridProperties(
                frozenRowCount: 1,
              ),
            ),
            fields: 'gridProperties.frozenRowCount',
          ),
        ),
      ];
      
      await _sheetsApi!.spreadsheets.batchUpdate(
        sheets.BatchUpdateSpreadsheetRequest(requests: formatRequests),
        spreadsheetId,
      );
      
      return spreadsheetId;
    } catch (e) {
      throw Exception('Failed to setup workout tracking spreadsheet: ${e.toString()}');
    }
  }
  
  // Save workout to spreadsheet
  Future<void> saveWorkoutSession(String spreadsheetId, WorkoutSession session) async {
    try {
      if (_sheetsApi == null) {
        await init();
      }
      
      // Get the next available row in the Workouts sheet
      final response = await _sheetsApi!.spreadsheets.values.get(
        spreadsheetId,
        'Workouts!A:A',
      );
      
      final values = response.values ?? [];
      final nextRow = values.length + 1;
      
      // Format date and times
      final dateStr = '${session.startTime.year}-${session.startTime.month.toString().padLeft(2, '0')}-${session.startTime.day.toString().padLeft(2, '0')}';
      final startTimeStr = '${session.startTime.hour.toString().padLeft(2, '0')}:${session.startTime.minute.toString().padLeft(2, '0')}';
      final endTimeStr = session.endTime != null
          ? '${session.endTime!.hour.toString().padLeft(2, '0')}:${session.endTime!.minute.toString().padLeft(2, '0')}'
          : '';
      
      // Create the row data
      final rowData = [
        session.id,
        session.routineId,
        dateStr,
        startTimeStr,
        endTimeStr,
        session.totalDurationMinutes?.toString() ?? '',
        session.totalWeightLifted?.toString() ?? '',
        session.caloriesBurned?.toString() ?? '',
        session.notes ?? '',
        session.completedExercises.length.toString(),
      ];
      
      // Update the spreadsheet
      await _sheetsApi!.spreadsheets.values.update(
        sheets.ValueRange(values: [rowData]),
        spreadsheetId,
        'Workouts!A$nextRow:J$nextRow',
        valueInputOption: 'USER_ENTERED',
      );
    } catch (e) {
      throw Exception('Failed to save workout session: ${e.toString()}');
    }
  }
  
  // Setup nutrition tracking spreadsheet
  Future<String> setupNutritionTrackingSpreadsheet(User user) async {
    try {
      if (_sheetsApi == null) {
        await init();
      }
      
      // Create the spreadsheet
      final spreadsheetId = await createSpreadsheet('Nutrition Tracking - ${user.displayName}');
      
      // Create sheets for different tracking purposes
      final requests = [
        sheets.Request(
          addSheet: sheets.AddSheetRequest(
            properties: sheets.SheetProperties(
              title: 'Daily Summary',
              gridProperties: sheets.GridProperties(
                rowCount: 1000,
                columnCount: 15,
              ),
            ),
          ),
        ),
        sheets.Request(
          addSheet: sheets.AddSheetRequest(
            properties: sheets.SheetProperties(
              title: 'Meals',
              gridProperties: sheets.GridProperties(
                rowCount: 1000,
                columnCount: 10,
              ),
            ),
          ),
        ),
        sheets.Request(
          addSheet: sheets.AddSheetRequest(
            properties: sheets.SheetProperties(
              title: 'Weight Tracking',
              gridProperties: sheets.GridProperties(
                rowCount: 1000,
                columnCount: 5,
              ),
            ),
          ),
        ),
      ];
      
      // Execute the batch update to create sheets
      await _sheetsApi!.spreadsheets.batchUpdate(
        sheets.BatchUpdateSpreadsheetRequest(requests: requests),
        spreadsheetId,
      );
      
      // Add headers to Daily Summary sheet
      await _sheetsApi!.spreadsheets.values.update(
        sheets.ValueRange(
          values: [
            [
              'Date',
              'Target Calories',
              'Actual Calories',
              'Target Protein (g)',
              'Actual Protein (g)',
              'Target Carbs (g)',
              'Actual Carbs (g)',
              'Target Fat (g)',
              'Actual Fat (g)',
              'Calories Burned',
              'Net Calories',
              'Water Intake (L)',
              'Meal Count',
              'Weight (kg)',
              'Notes',
            ],
          ],
        ),
        spreadsheetId,
        'Daily Summary!A1:O1',
        valueInputOption: 'USER_ENTERED',
      );
      
      // Add headers to Meals sheet
      await _sheetsApi!.spreadsheets.values.update(
        sheets.ValueRange(
          values: [
            [
              'ID',
              'Date',
              'Time',
              'Meal Type',
              'Total Calories',
              'Protein (g)',
              'Carbs (g)',
              'Fat (g)',
              'Food Items',
              'Notes',
            ],
          ],
        ),
        spreadsheetId,
        'Meals!A1:J1',
        valueInputOption: 'USER_ENTERED',
      );
      
      // Add headers to Weight Tracking sheet
      await _sheetsApi!.spreadsheets.values.update(
        sheets.ValueRange(
          values: [
            [
              'Date',
              'Weight (kg)',
              'Body Fat %',
              'BMI',
              'Notes',
            ],
          ],
        ),
        spreadsheetId,
        'Weight Tracking!A1:E1',
        valueInputOption: 'USER_ENTERED',
      );
      
      // Format headers (make bold, freeze)
      final formatRequests = [
        sheets.Request(
          repeatCell: sheets.RepeatCellRequest(
            range: sheets.GridRange(
              sheetId: 0,
              startRowIndex: 0,
              endRowIndex: 1,
              startColumnIndex: 0,
              endColumnIndex: 15,
            ),
            cell: sheets.CellData(
              userEnteredFormat: sheets.CellFormat(
                textFormat: sheets.TextFormat(
                  bold: true,
                ),
                backgroundColor: sheets.Color(
                  red: 0.9,
                  green: 0.9,
                  blue: 0.9,
                ),
              ),
            ),
            fields: 'userEnteredFormat(textFormat,backgroundColor)',
          ),
        ),
        sheets.Request(
          updateSheetProperties: sheets.UpdateSheetPropertiesRequest(
            properties: sheets.SheetProperties(
              sheetId: 0,
              gridProperties: sheets.GridProperties(
                frozenRowCount: 1,
              ),
            ),
            fields: 'gridProperties.frozenRowCount',
          ),
        ),
      ];
      
      await _sheetsApi!.spreadsheets.batchUpdate(
        sheets.BatchUpdateSpreadsheetRequest(requests: formatRequests),
        spreadsheetId,
      );
      
      return spreadsheetId;
    } catch (e) {
      throw Exception('Failed to setup nutrition tracking spreadsheet: ${e.toString()}');
    }
  }
  
  // Save weight entry to spreadsheet
  Future<void> saveWeightEntry(String spreadsheetId, WeightEntry entry) async {
    try {
      if (_sheetsApi == null) {
        await init();
      }
      
      // Get the next available row in the Weight Tracking sheet
      final response = await _sheetsApi!.spreadsheets.values.get(
        spreadsheetId,
        'Weight Tracking!A:A',
      );
      
      final values = response.values ?? [];
      final nextRow = values.length + 1;
      
      // Format date
      final dateStr = '${entry.date.year}-${entry.date.month.toString().padLeft(2, '0')}-${entry.date.day.toString().padLeft(2, '0')}';
      
      // Calculate BMI if height is available
      double? bmi;
      // TODO: Implement BMI calculation based on user profile
      
      // Create the row data
      final rowData = [
        dateStr,
        entry.weightKg.toString(),
        entry.bodyFatPercentage?.toString() ?? '',
        bmi?.toString() ?? '',
        entry.notes ?? '',
      ];
      
      // Update the spreadsheet
      await _sheetsApi!.spreadsheets.values.update(
        sheets.ValueRange(values: [rowData]),
        spreadsheetId,
        'Weight Tracking!A$nextRow:E$nextRow',
        valueInputOption: 'USER_ENTERED',
      );
    } catch (e) {
      throw Exception('Failed to save weight entry: ${e.toString()}');
    }
  }
  
  // Save meal entry to spreadsheet
  Future<void> saveMealEntry(String spreadsheetId, MealEntry entry) async {
    try {
      if (_sheetsApi == null) {
        await init();
      }
      
      // Get the next available row in the Meals sheet
      final response = await _sheetsApi!.spreadsheets.values.get(
        spreadsheetId,
        'Meals!A:A',
      );
      
      final values = response.values ?? [];
      final nextRow = values.length + 1;
      
      // Format date and time
      final dateStr = '${entry.dateTime.year}-${entry.dateTime.month.toString().padLeft(2, '0')}-${entry.dateTime.day.toString().padLeft(2, '0')}';
      final timeStr = '${entry.dateTime.hour.toString().padLeft(2, '0')}:${entry.dateTime.minute.toString().padLeft(2, '0')}';
      
      // Create food items summary
      final foodItemsSummary = entry.foodItems.map((item) => item.name).join(', ');
      
      // Create the row data
      final rowData = [
        entry.id,
        dateStr,
        timeStr,
        entry.mealType,
        entry.totalCalories.toString(),
        entry.totalProteinGrams.toString(),
        entry.totalCarbsGrams.toString(),
        entry.totalFatGrams.toString(),
        foodItemsSummary,
        entry.notes ?? '',
      ];
      
      // Update the spreadsheet
      await _sheetsApi!.spreadsheets.values.update(
        sheets.ValueRange(values: [rowData]),
        spreadsheetId,
        'Meals!A$nextRow:J$nextRow',
        valueInputOption: 'USER_ENTERED',
      );
      
      // Now update the daily summary
      await _updateDailySummary(spreadsheetId, entry.dateTime);
    } catch (e) {
      throw Exception('Failed to save meal entry: ${e.toString()}');
    }
  }
  
  // Update daily nutrition summary
  Future<void> _updateDailySummary(String spreadsheetId, DateTime date) async {
    try {
      // TODO: Implement daily summary update by aggregating meal data for the day
    } catch (e) {
      throw Exception('Failed to update daily summary: ${e.toString()}');
    }
  }
} 