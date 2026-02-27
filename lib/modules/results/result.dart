
class MoodResult {
  String formatMood(String mood) {
    switch (mood.toLowerCase()) {
      case 'happy':
        return '😊 Happy ';
      case 'sad':
        return '😞 Sad  ';
      case 'tired':
        return '😴 Tired ';
      case 'stressed':
        return '😰 Stressed ';
      case 'normal':
      default:
        return '😐 Normal  ';
    }
  }
}

class LightResult {
  String formatLighting(String lighting) {
    switch (lighting.toLowerCase()) {
      case 'too bright':
        return '☀️ Too Bright ';
      case 'bright':
        return '☀️ Bright ';
      case 'good lighting':
        return '✅ Good Lighting  ';
      case 'dim':
        return '🌙 Dim ';
      case 'too dark':
        return '🌙 Too Dark  ';
      default:
        return '❓ Unknown';
    }
  }
}