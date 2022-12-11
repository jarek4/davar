String capitalize(String str) {
  if (str.length > 1) {
    return str[0].toUpperCase() + str.substring(1);
  }
  if (str.length == 1) return str[0].toUpperCase();
  if (str.isEmpty) return '';
  return '';
}
