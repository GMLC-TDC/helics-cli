// Common library imports
import 'jquery';
import 'bootstrap';
import 'bootstrap-table';
import 'dark-mode-switch';

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

import {test} from "./debug";
import {homeSetup} from "./home";

// Style imports
import '../scss/index.scss';

// HELICS-cli Web Interface Specific Code

homeSetup();
debugSetup()