// This is your first fully working Tabris.js app. Feel free to alter as you please.
// Changes are saved automatically and are immediately available on your device.

// Create a push button and add it to the content view
new tabris.Button({
  left: 16, top: 16,
  text: 'Button'
}).on('select', function() {
  this.text = 'Pressed';
}).appendTo(tabris.ui.contentView);
