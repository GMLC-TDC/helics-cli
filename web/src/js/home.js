export function homeSetup(){
// Button click handler events.
    $('#fastForwardFederation').on('click', () => signal('FastForwardFederation', reloadCharts));
    $('#stopFederation').on('click', () => signal('StopFederation', reloadCharts));
    $('#signalFederation').on('click', () => signal('SignalFederation', reloadCharts, $('#nextTimeStep').val()));

// Bootstrap-table cell highlighting logic.
    window.cellStyle = function (value) {
        if (value === true)
            return {
                css: {
                    background: 'springgreen',
                    color: 'black'
                }
            };
        return {};
    };
}

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
    if (callback !== null) messagePackage.success = callback;
    if (value !== null) messagePackage.data = value;

    $.ajax(messagePackage);
}