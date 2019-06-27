import {app} from 'tabris';

app.on({backNavigation: (event) => event.preventDefault()});
