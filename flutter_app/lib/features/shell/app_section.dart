/// Primary public sections reachable from the navigation drawer.
enum AppSection {
  glossary,
  leadSkaterSigns,
}

extension AppSectionRoute on AppSection {
  String get route {
    switch (this) {
      case AppSection.glossary:
        return '/';
      case AppSection.leadSkaterSigns:
        return '/lead-skater-signs';
    }
  }

  String get drawerLabel {
    switch (this) {
      case AppSection.glossary:
        return 'Glossary';
      case AppSection.leadSkaterSigns:
        return 'Lead skater signs';
    }
  }

}

AppSection? appSectionFromPath(String path) {
  if (path.startsWith('/lead-skater-signs')) {
    return AppSection.leadSkaterSigns;
  }
  if (path == '/' || path.startsWith('/glossary')) {
    return AppSection.glossary;
  }
  return null;
}
