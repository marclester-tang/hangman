bool isWordGuessed(List<String> challengeWord, List<String> selectedLetters) =>
    challengeWord.every((String letter) => selectedLetters.contains(letter));
