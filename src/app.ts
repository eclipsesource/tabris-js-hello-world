// This is a simple Tabris.js app. Feel free to modify as you please.

import {Button, TextView} from 'tabris';
import * as tabris from 'tabris';

// Create a push button and add it to the content view
let button = new Button({
  centerX: 0, centerY: 0,
  text: 'Tap here'
}).appendTo(tabris.contentView);

// Create a text view and add it too
let textView = new TextView({
  centerX: 0, top: [button, 50],
  font: '24px'
}).appendTo(tabris.contentView);

let tabrisVersion = (tabris as any).version;
// Change the text when the button is pressed
button.on({select: () => textView.text = `Tabris.js ${tabrisVersion} rocks!`});
