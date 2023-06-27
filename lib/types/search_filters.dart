enum SearchFilter {
  social,
  message,
  post,
  project,
  job,
}

extension SearchExtension on SearchFilter {
  String get name {
    switch (this) {
      case SearchFilter.job:
        return 'Jobs';
      case SearchFilter.project:
        return 'Projects';
      case SearchFilter.message:
        return 'Messages';
      default:
        return 'Socials';
    }
  }
}
