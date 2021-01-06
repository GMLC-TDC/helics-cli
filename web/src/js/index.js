// Common library imports
import 'bootstrap';
import 'bootstrap-table';
import 'dark-mode-switch';
import $ from 'jquery';
window.jQuery = window.$ = $;

import {library, dom} from "@fortawesome/fontawesome-svg-core"
import {
    faSync,
    faCaretSquareDown,
    faPlay,
    faPause,
    faStop,
    faAngleDoubleRight, faQuestion
} from "@fortawesome/fontawesome-free-solid"

library.add(faSync, faCaretSquareDown, faPlay, faPause, faStop, faAngleDoubleRight, faQuestion);
dom.watch();

import Debug from "./Debug";
import Home from "./Home";

// Style imports
import '../scss/index.scss';

// HELICS-cli Web Interface Specific Code
let homeWindow = new Home
homeWindow.homeSetup();
window["homeWindow"] = homeWindow;

let debugWindow = new Debug
debugWindow.debugSetup()
window["debugWindow"] = debugWindow;