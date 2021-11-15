// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs";
// import Turbolinks from "turbolinks";
import * as ActiveStorage from "@rails/activestorage";
import "channels";

import "organi/bootstrap.min.js";
import "organi/jquery-3.3.1.min.js";
window.$ = window.jQuery = $;
import "organi/jquery.nice-select.min.js";
import "organi/jquery.slicknav.js";
import "organi/jquery-ui.min.js";
import "organi/mixitup.min.js";
import "organi/owl.carousel.min.js";
import "organi/main.js";
import "packs/custom.js";

Rails.start();
// Turbolinks.start();
ActiveStorage.start();
