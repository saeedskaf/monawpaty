import 'package:monawpaty/src/shared/app_config.dart';

class ConstantsService {
  static String baseUrl = AppConfig.baseUrl;
  static String logInEndpoint = "/authentications/login";
  static String registrationEndpoint = "/authentications/signup";
  static String verifyOtpEndpoint = "/authentications/verify_otp";
  static String getResIdEndpoint = "/reservations/get_reservations";
  static String bookShiftEndpoint = "/reservations/reservepost";
  static String onCallEndpoint = "/user_requests/reservepost_onCall";
  static String getTableShiftsEndpoint = "/reservations/valid_reservation";
  static String cancelRequestEndpoint = "/user_requests/reservepost_cancel";
  static String repairRequestEndpoint = "/user_requests/reservepost_repair";
  static String getShiftCancelEndpoint = "/user_requests/query_about_cancel";
  static String getShiftRepairEndpoint = "/user_requests/query_about_repair";
  static String changePasswordEndpoint = "/authentications/change-password";
  static String getCountShiftsEndpoint = "/user_query/count_shift_post";
  static String getMyReservationsEndpoint = "/user_query/myreservations";
  static String passwordResetEndpoint = "/authentications/password_reset/";
  static String passwordConfirmEndpoint =
      "/authentications/password_reset/confirm/";
}
