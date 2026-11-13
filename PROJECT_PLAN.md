# Pocket Canvas Project Plan

## Project Overview

Pocket Canvas is a mobile drawing application built with Flutter and Dart. The app will allow users to draw with their finger on a digital canvas, select colors and brush sizes, erase marks, clear the canvas, and draw over a built-in picture. The project will be developed in Visual Studio Code and designed to run on Android and iOS from one codebase.

The goal is to create a small but polished mobile app that demonstrates user input, visible display changes, image assets, mobile interaction, and persistent data storage.

## Assignment Requirements

1. **At least one screen:** The app will include a drawing screen and may also include a home screen.
2. **User input:** Users will draw by dragging a finger across the screen and use buttons to select tools.
3. **Display changes after input:** Lines will appear on the canvas as the user draws.
4. **Display a picture:** The app will include a built-in background image or coloring-page image.
5. **Custom app icon:** The app will use a custom paintbrush, pencil, or colorful canvas icon.
6. **Stretch challenge:** Users will be able to save and reload drawings using local storage.

## Development Environment

- Visual Studio Code
- Flutter SDK and Dart SDK
- Flutter and Dart extensions for Visual Studio Code
- Git for version control
- A web browser for early testing
- An Android phone or emulator for mobile testing
- Flutter packages for local storage and app icons

Android Studio will not be used as the primary code editor. If Android SDK tools are needed for building or testing Android applications, they can be installed separately or configured through Flutter's setup process.

## Planned User Experience

When the user opens Pocket Canvas, they will see a simple home screen with the application title and a button to begin drawing. The drawing screen will contain a canvas, a background picture, and a toolbar.

Users will be able to:

- Drag a finger across the canvas to draw
- Select different brush colors
- Change the brush size
- Use an eraser
- Clear the current drawing
- Save the drawing
- Load a previously saved drawing
- Return to the home screen

The app will provide immediate visual feedback. Every time the user moves their finger, a line or brush stroke will appear on the canvas.

## Technical Design

### Main Screens

#### Home Screen

- Application title
- Custom logo or icon
- New Drawing button
- Load Drawing button
- Optional instructions

#### Drawing Screen

- Drawing canvas
- Background image
- Color selection buttons
- Brush-size controls
- Eraser button
- Undo button
- Clear button
- Save button
- Back button

### Drawing System

The app will record touch movement using Flutter gesture detection. Each drawing stroke will be stored as a collection of points. A custom painter will use those points to render the strokes on the canvas.

A stroke will contain information such as its points, color, brush size, and whether it is an eraser stroke. This allows the app to redraw the user's work whenever the screen updates and makes undo functionality possible.

### Picture Display

The app will include one or more built-in images in the project's asset folder. Possible images include a coloring page, landscape, cartoon character, or geometric design. The image will appear underneath the user's drawing so that the user can color or add details to it.

### Local Storage

For the stretch challenge, the app will save drawings locally. Saved data will include the points, colors, brush sizes, and background image selection. The first version may store one drawing; multiple saved drawings can be added if time allows.

## Suggested Project Structure

```text
lib/
  main.dart
  models/
    drawing_stroke.dart
  screens/
    home_screen.dart
    drawing_screen.dart
  widgets/
    drawing_canvas.dart
    color_picker.dart
    drawing_toolbar.dart
  services/
    storage_service.dart
  theme/
    app_theme.dart

assets/
  images/
    coloring_page.png
    app_icon.png
```

This structure separates drawing logic, user interface, storage, and reusable controls.

## Implementation Steps and Milestones

### 1. Create the Flutter Project

- Install and verify Flutter.
- Install the Flutter and Dart extensions in Visual Studio Code.
- Create a new Flutter project.
- Run the default application.
- Confirm that the project works in a browser or on an Android device.
- Replace the default Flutter screen with a basic Pocket Canvas home screen.

**Milestone:** The Flutter project runs successfully, and the home screen is visible.

### 2. Build the Home Screen

- Add the application title and color theme.
- Add a logo or image.
- Add a button that opens the drawing screen.
- Add basic navigation between screens.
- Test that the buttons work correctly.

**Milestone:** The user can move between the home screen and drawing screen.

### 3. Create the Drawing Canvas

- Create a custom canvas widget.
- Detect finger presses and movement.
- Record touch points.
- Draw lines between the points.
- Make sure the drawing updates immediately.
- Test drawing with different shapes and directions.

**Milestone:** The user can draw smoothly on a blank canvas.

### 4. Add Colors and Brush Sizes

- Create color-selection buttons.
- Add at least three colors.
- Add small, medium, and large brush sizes.
- Update the active brush when a control is tapped.
- Show which color and brush size are currently selected.

**Milestone:** The user can control the appearance of the drawing.

### 5. Add the Background Picture

- Add an image to the project asset folder.
- Register the image in the Flutter configuration.
- Display the image underneath the drawing canvas.
- Make sure the image scales properly on different screen sizes.
- Test drawing over the image.

**Milestone:** The app clearly displays a picture and allows drawing over it.

### 6. Add the Eraser, Clear, and Undo Tools

- Add an eraser mode.
- Add a clear button.
- Confirm before clearing if appropriate.
- Store completed strokes in a list.
- Add an undo button that removes the most recent stroke.
- Safely handle undo when there are no strokes.

**Milestone:** The user can correct or remove artwork.

### 7. Add Local Saving

- Convert drawing strokes into data that can be saved.
- Store the drawing data locally.
- Add Save and Load buttons.
- Test closing and reopening the app.

**Milestone:** The drawing remains available after the application closes.

### 8. Add the Custom App Icon

- Create or select a paintbrush, pencil, or canvas design.
- Prepare the image in the required icon sizes.
- Configure the application to use the custom icon.
- Test that the icon appears correctly on the device or emulator.

**Milestone:** The installed app has a custom icon.

### 9. Test and Improve the Application

- Test drawing with slow and fast finger movements.
- Test all colors and brush sizes.
- Test the eraser, clear, undo, saving, and loading.
- Test different screen sizes.
- Check that the background image displays correctly.
- Fix layout, performance, and usability problems.

**Milestone:** A complete, working version of Pocket Canvas is ready to demonstrate.

## Two-Week Schedule

### Days 1–2: Setup and Practice

- Install Flutter and configure Visual Studio Code.
- Create the project and run the default Flutter application.
- Complete a basic Flutter tutorial.
- Review Dart variables, classes, functions, and lists.
- Create a basic home screen.

**Milestone:** The project runs and the home screen is visible.

### Days 3–4: Navigation and Layout

- Build the home screen.
- Add the drawing screen.
- Add navigation buttons.
- Create the basic toolbar layout.
- Add the project color theme.

**Milestone:** The user can move between the home and drawing screens.

### Days 5–6: Core Drawing

- Create the custom painter.
- Detect touch movement.
- Draw lines on the screen.
- Store drawing strokes.
- Test drawing performance.

**Milestone:** The user can draw smoothly on a blank canvas.

### Days 7–8: Drawing Controls

- Add colors.
- Add brush sizes.
- Add an eraser.
- Add a clear button.
- Add undo functionality.

**Milestone:** The user can control the drawing and remove mistakes.

### Days 9–10: Picture and Application Design

- Add a background image.
- Allow drawing over the image.
- Improve spacing, colors, text, and buttons.
- Add instructions or visual labels.

**Milestone:** The app satisfies the picture requirement and has a usable interface.

### Days 11–12: Save and Load Feature

- Design the drawing data format.
- Implement local storage.
- Add Save and Load buttons.
- Test closing and reopening the app.

**Milestone:** The drawing persists after the application closes.

### Days 13–14: Final Testing and Presentation

- Add the custom icon.
- Test the app on a mobile device.
- Fix visual and functional bugs.
- Remove unnecessary features if they cause instability.
- Prepare screenshots and a project demonstration.
- Confirm that every assignment requirement is satisfied.

**Milestone:** A complete Pocket Canvas demonstration is ready.

## Minimum Viable Product

The minimum version will include:

- Home screen
- Drawing screen
- Touch drawing
- Three brush colors
- Multiple brush sizes
- Eraser
- Clear button
- One background image
- Custom app icon
- Working Android version

This version satisfies all five required project features.

## Stretch Features

If the core app is completed early, possible additions include:

- Local save and load functionality
- Multiple background pictures
- Undo and redo
- Multiple drawing files
- A custom color picker
- Dark mode
- A gallery screen
- Exporting a drawing as an image
- Drawing statistics such as stroke count
- Sound effects when buttons are pressed

The most important stretch feature is local storage because it directly satisfies the persistence challenge.

## Risks and Solutions

### Drawing Is Not Smooth

If drawing appears delayed or choppy, simplify the drawing logic, reduce unnecessary screen updates, and test the application in release mode.

### Saving Is Too Complicated

If saving complete drawings becomes difficult, first save one drawing using a simpler data format. The core drawing experience remains the priority.

### The Interface Becomes Too Crowded

If the toolbar does not fit well on a small screen, place controls in a bottom panel, use icons instead of long labels, or separate tools into a second screen.

### Extra Features Take Too Long

Prioritize touch drawing, picture display, controls, and the custom icon before working on advanced features.

## Descriptive Final Outcome

At the end of the sprint, Pocket Canvas will be a functional cross-platform Flutter application that allows users to draw on a picture using touch controls. Users will be able to choose colors, adjust brush sizes, erase marks, clear the canvas, and save their work for later. The application will have a custom visual identity, a simple multi-screen interface, and a clear demonstration of mobile input and changing display content.
