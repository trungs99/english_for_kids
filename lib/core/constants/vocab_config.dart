/// Vocabulary configuration for fuzzy matching with ML Kit labels
/// Maps target words to allowed labels that ML Kit might return
final Map<String, List<String>> vocabConfig = {
  'Apple': ['Apple', 'Fruit', 'Food', 'Red'],
  'Bottle': ['Bottle', 'Water bottle', 'Drinkware', 'Plastic', 'Container'],
  'Cup': ['Cup', 'Mug', 'Coffee cup', 'Tableware', 'Drinkware'],
  'Desk': ['Desk', 'Table', 'Furniture', 'Office', 'Wood'],
  'Egg': ['Egg', 'Food', 'Oval', 'White', 'Ingredient', 'Breakfast'],
};

/// Check if a detected label matches the target word
bool checkLabelMatch(String targetWord, String detectedLabel, double confidence) {
  if (confidence < 0.7) return false;
  
  final allowedLabels = vocabConfig[targetWord];
  if (allowedLabels == null) return false;
  
  // Case-insensitive matching
  final lowerDetected = detectedLabel.toLowerCase();
  final lowerTarget = targetWord.toLowerCase();
  
  // Exact match or contains target word
  if (lowerDetected == lowerTarget || lowerDetected.contains(lowerTarget)) {
    return true;
  }
  
  // Check against allowed labels
  for (final allowed in allowedLabels) {
    final lowerAllowed = allowed.toLowerCase();
    if (lowerDetected == lowerAllowed || 
        lowerDetected.contains(lowerAllowed) ||
        lowerAllowed.contains(lowerDetected)) {
      return true;
    }
  }
  
  return false;
}

