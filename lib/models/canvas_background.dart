enum CanvasBackground { blank, sunset, mountains, garden }

extension CanvasBackgroundDetails on CanvasBackground {
  String get label => switch (this) {
        CanvasBackground.blank => 'Blank',
        CanvasBackground.sunset => 'Sunset',
        CanvasBackground.mountains => 'Mountains',
        CanvasBackground.garden => 'Garden',
      };
}
