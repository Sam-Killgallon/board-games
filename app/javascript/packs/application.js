// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import 'channels';
import * as RailsUJS from '@rails/ujs';
import * as RailsActiveStorage from '@rails/activestorage';
import * as Turbolinks from 'turbolinks';
import flatpickr from 'flatpickr';
import 'flatpickr/dist/flatpickr.css';

RailsUJS.start()
RailsActiveStorage.start()
Turbolinks.start();

document.addEventListener('turbolinks:load', () => {
  flatpickr('[data-flatpickr="true"]', {
    enableTime: true
  })
})
