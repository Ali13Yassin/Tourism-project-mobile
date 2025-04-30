

String slugify(String name) {
  return name
      .toLowerCase()
      .replaceAll(RegExp(r'[^\w\s-]'), '') // remove punctuation
      .trim()
      .replaceAll(RegExp(r'\s+'), '-'); // replace spaces with hyphens
}
