dynamic images(dynamic type) {
  print(type);
  switch (type) {
    case "clear":
      return "assets/clear_sky.png";
    case "snow":
      return "assets/snow.png";
    case "rain":
      return "assets/rain.png";
    case "lightining":
      return "assets/lightining.png";
    case "cloudy":
      return "assets/cloudy.png";
    case "mist":
      return "assets/mist.png";
    default:
      return "assets/cloudy.png";
  }
}






// Map<String, dynamic> imagePath = {
// "snow":"assets/snow.png",
// "light":"assets/light.png",
// "rain":"assets/rain.png",
// "sunny":"assets/sunny.png",
// "clear_sky":"assets/clear_sky.png"
// };
// Map<String, dynamic> background = {};