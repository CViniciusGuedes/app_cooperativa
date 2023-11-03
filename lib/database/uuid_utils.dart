class UuidUtils {
  static String simplify(String uuid) {
    return uuid.substring(0, uuid.indexOf('-'));
  }
}
