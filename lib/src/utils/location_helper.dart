class LocationHelper {
  /// Maps a time zone abbreviation to a corresponding location string for use with `tz.getLocation()`.
  ///
  /// This function accepts a time zone abbreviation (e.g., "EST", "PDT") and returns a
  /// `Continent/City` formatted location string compatible with the `timezone` package's
  /// `tz.getLocation()` method, taking into account both standard and daylight saving times
  /// for applicable time zones.
  ///
  /// - [timeZoneAbbreviation]: The abbreviation of the time zone (e.g., "EST", "PST", "EDT").
  ///
  /// Returns a `String` representing the location compatible with `tz.getLocation()`.
  static String getTzLocation(String timeZoneAbbreviation) {
    switch (timeZoneAbbreviation) {
      // US Time Zones with Daylight Saving Time
      case "EST":
        return "America/New_York"; // Eastern Standard Time
      case "EDT":
        return "America/New_York"; // Eastern Daylight Time
      case "CST":
        return "America/Chicago"; // Central Standard Time
      case "CDT":
        return "America/Chicago"; // Central Daylight Time
      case "MST":
        return "America/Denver"; // Mountain Standard Time (excluding Arizona)
      case "MDT":
        return "America/Denver"; // Mountain Daylight Time
      case "PST":
        return "America/Los_Angeles"; // Pacific Standard Time
      case "PDT":
        return "America/Los_Angeles"; // Pacific Daylight Time

      // European Time Zones with Daylight Saving Time
      case "GMT":
        return "Europe/London"; // Greenwich Mean Time
      case "BST":
        return "Europe/London"; // British Summer Time
      case "CET":
        return "Europe/Paris"; // Central European Time
      case "CEST":
        return "Europe/Paris"; // Central European Summer Time
      case "EET":
        return "Europe/Helsinki"; // Eastern European Time
      case "EEST":
        return "Europe/Helsinki"; // Eastern European Summer Time

      // Australian Time Zones with Daylight Saving Time
      case "AEST":
        return "Australia/Sydney"; // Australian Eastern Standard Time
      case "AEDT":
        return "Australia/Sydney"; // Australian Eastern Daylight Time
      case "ACST":
        return "Australia/Adelaide"; // Australian Central Standard Time
      case "ACDT":
        return "Australia/Adelaide"; // Australian Central Daylight Time

      // Other Standard Time Zones
      case "UTC":
        return "UTC";
      case "IST":
        return "Asia/Kolkata"; // Indian Standard Time
      case "JST":
        return "Asia/Tokyo"; // Japan Standard Time
      case "NZST":
        return "Pacific/Auckland"; // New Zealand Standard Time
      case "NZDT":
        return "Pacific/Auckland"; // New Zealand Daylight Time
      case "AKST":
        return "America/Anchorage"; // Alaska Standard Time
      case "AKDT":
        return "America/Anchorage"; // Alaska Daylight Time

      // Additional time zones without DST
      case "HST":
        return "Pacific/Honolulu"; // Hawaii Standard Time (no DST)
      case "KST":
        return "Asia/Seoul"; // Korea Standard Time
      case "HKT":
        return "Asia/Hong_Kong"; // Hong Kong Time
      case "SGT":
        return "Asia/Singapore"; // Singapore Time
      case "BRT":
        return "America/Sao_Paulo"; // Brasilia Time

      // Default to UTC if the time zone is unrecognized
      default:
        return "UTC";
    }
  }
}
