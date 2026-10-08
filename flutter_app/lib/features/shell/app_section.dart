/// Primary public sections reachable from the navigation drawer.
/// Order matches the drawer list.
enum AppSection {
  glossary,
  tourReportTemplate,
  leadSkaterSigns,
}

extension AppSectionRoute on AppSection {
  String get route {
    switch (this) {
      case AppSection.glossary:
        return '/';
      case AppSection.tourReportTemplate:
        return '/tour-report-template';
      case AppSection.leadSkaterSigns:
        return '/lead-skater-signs';
    }
  }

  String get drawerLabel {
    switch (this) {
      case AppSection.glossary:
        return 'Glossary';
      case AppSection.tourReportTemplate:
        return 'Tour report template';
      case AppSection.leadSkaterSigns:
        return 'Lead skater signs';
    }
  }
}

AppSection? appSectionFromPath(String path) {
  if (path.startsWith('/tour-report-template')) {
    return AppSection.tourReportTemplate;
  }
  if (path.startsWith('/lead-skater-signs')) {
    return AppSection.leadSkaterSigns;
  }
  if (path == '/' || path.startsWith('/glossary')) {
    return AppSection.glossary;
  }
  return null;
}
