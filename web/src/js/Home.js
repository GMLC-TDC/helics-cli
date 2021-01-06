export default class {
    homeSetup() {
// Button click handler events.
        $('#fastForwardFederation').on('click', () => this.signal('fast-forward-federation', this.reloadCharts));
        $('#stopFederation').on('click', () => this.signal('stop-federation', this.reloadCharts));
        $('#signalFederation').on('click', () => this.signal('signal-federation', this.reloadCharts, $('#nextTimeStep').val()));
        this.reloadCharts();
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

    reloadCharts() {
        $.each($("table.table"), function (obj, value) {
            $(value).bootstrapTable('refresh');
        });
    }

// AJAX call to signal server even logic.
    signal(endpoint, callback = null, value = null) {
        let messagePackage = {
            url: "/api/" + endpoint,
            type: "PUT",
        }
        if (callback !== null) messagePackage.success = callback;
        if (value !== null) messagePackage.data = value;

        $.ajax(messagePackage);
    }
}