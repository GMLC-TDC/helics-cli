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
    faAngleDoubleRight
} from "@fortawesome/fontawesome-free-solid"

library.add(faSync, faCaretSquareDown, faPlay, faPause, faStop, faAngleDoubleRight);
dom.watch();

// Style imports
import '../scss/index.scss';

// HELICS-cli Web Interface Specific Code

function reloadCharts() {
    $.each($("table.table"), function (obj, value) {
        $(value).bootstrapTable('refresh');
    });
}

// AJAX call to signal server even logic.
function signal(endpoint, callback = null, value = null) {
    let messagePackage = {
        url: "/api/" + endpoint,
        type: "PUT",
    }
    if (value !== null) messagePackage.data = value;
    if (callback !== null) messagePackage.success = callback;

    $.ajax(messagePackage);
}

// Button click handler events.
$('#fastForwardFederation').on('click', () => signal('FastForwardFederation', reloadCharts()));
$('#stopFederation').on('click', () => signal('StopFederation', reloadCharts()));
$('#signalFederation').on('click', () => signal('SignalFederation', reloadCharts(), $('#nextTimeStep').val()));

// Bootstrap-table cell highlighting logic.
let cellStyle = function (value) {
    if (value === true)
        return {
            css: {
                background: 'springgreen',
                color: 'black'
            }
        };
    return {};
};
window.cellStyle = cellStyle;