String slugify(String input) {
  return input
      .toLowerCase()
      .replaceAll(RegExp(r'[^\w\s-]'), '') // remove punctuation
      .replaceAll(RegExp(r'\s+'), '-')     // replace spaces with hyphens
      .replaceAll(RegExp(r'-+'), '-')      // remove duplicate hyphens
      .trim();
}