import '../models/panel.dart';

List<Panel> faqPanels = [
  Panel('How can I change to an open-ended session?',
      'Tap on \'SET TIME\' on the home screen and switch on \'Open-ended session\'.'),
  Panel(
      'How can I adjust the meditation bells?',
      'Tap on the bell icon on the home screen (bottom-left).'
          '\n\n'
          'A menu will appear where you can adjust the start, interval and end bells.'),
  Panel(
      'Why can\'t I increase the bell interval frequency?',
      'The bell interval frequency is limited by the total time set. '
          'Therefore, you would either need to increase the total fixed time, or change the '
          'timer to an open-ended session.'),
  Panel(
      'How can I add in ambient sounds or music?',
      'Tap the music icon on the home screen (bottom center-left). '
          '\n\nA series of ambient tracks, from nature sounds to meditation music, will then be available to select from.'),
  Panel(
      'How can I adjust the ambience volume?',
      'Tap the music note icon on the ambient track you have selected.'
          '\n\nThen, a pop-up menu will appear where you can adjust the audio volume.'),
  Panel(
      'How can I create a new preset?',
      'Tap the preset icon on the home screen (bottom center-right).'
          '\n\nThen tap the plus icon to save the current timer settings as a new preset with a custom name.'),
  Panel(
      'How can I delete a preset?',
      'Tap on the arrow icon on the preset pop-up you wish to delete, which will display the preset details. '
          '\n\nThen, tap on the three dots icon (top-right), which will give you the option to delete the preset.'),
  Panel(
      'How can I delete a meditation record in my dashboard stats?',
      'Tap the dashboard icon on the home screen (bottom-right).'
          '\n\nThen tap the edit icon (top right) to view, and delete, your meditation records.\n\n'
          'Alternatively, you can reset all you saved data via \'Reset\' in Settings.'),
  Panel('How is my streak calculated?',
      'The number of consecutive days you have meditated for at least once a day for 1 minute or longer.'),
  Panel('Why can\'t I see the timer clock when a session is in progress?',
      'In Settings > Timer face make sure \'Show clock\' is turned on'),
  Panel('Is my personal/meditation data secure?',
      'Yes. This app does not save any data to a cloud database. All your data is 100% saved locally on your device only.\n\n')
];
