export default class {
    debugSetup() {
        $('#sendQuery').on('click', () =>
            this.getRequest('query-federation', this.renderQuery, this.renderError, this.getQueryString()));
        $('#signalFederation').on('click', () =>
            this.getRequest('signal-federation', null, null,"?target_time=" + $("#nextTimeStep").val()));

        this.getRequest("named-federate-target-name",
            function (data) {
                let dropdownOptions = "";
                if (Array.isArray(data)) {
                    data.forEach((element) => dropdownOptions += '<option value="' + element + '">' + element + '</option>');
                    $('#queryTargetName')[0].innerHTML = "<option disabled selected value=\"empty\"> -- select an option --</option>\n" + dropdownOptions;
                }
            }
        );

        $('#queryTargetSelect').on('change', () => this.debugBuildQueryTargetName());
        $('.helics-debug-dropdown').on('change', () => this.checkSendQuery());
    }

    debugBuildQueryTargetName() {
        this.visibilityControl('.helics-float-child', false);
        if ($('#queryTargetSelect').val() === "FEDERATE") {
            this.visibilityControl('.helics-federate-selector', true);
        } else {
            this.visibilityControl('.helics-core-selector', true);
        }
    }

    visibilityControl(tag, visible) {
        if (visible) {
            $(tag).show();
            $(tag + " select").prop("disabled", false);
        } else {
            $(tag).hide();
            $(tag + " select").prop("disabled", true);
        }
    }


    //TODO onChange dropdowns if not value = "empty" un-disable the Query Button id="sendQuery"
    // Ensure it is only comparing non-hidden children
    checkSendQuery() {
        let sendQueryButton = $("#sendQuery");
        sendQueryButton.prop("disabled", true);
        let enableButton = [];
        $.each($(".helics-debug-dropdown"), function (index, value) {
            if (!$(value).attr("disabled") && value.selectedIndex > 0) {
                enableButton.push(true);
            } else if (!$(value).attr("disabled")) {
                enableButton.push(false);
            }
        });
        sendQueryButton.prop("disabled", !enableButton.every(v => v === true));

        //
        // let queryTargetSelect = $("#queryTargetSelect")[0];
        // let queryTargetName = $("#queryTargetName")[0];
        // let queryTargetTopic = $("#queryTargetTopic")[0];
        // let queryFederateSpecific = $("#queryFederateSpecific")[0];

        //TODO need to disable button when first dropdown is changed but values are still at 0
        // which means interacting with the hidden tag during the checks

        // if (queryTargetSelect.selectedIndex !== 0) {
        //     if (queryTargetName.selectedIndex !== 0 && queryFederateSpecific.selectedIndex !== 0) {
        //         $("#sendQuery").prop("disabled", false)
        //     }
        //     else if (queryTargetTopic.selectedIndex !== 0){
        //         $("#sendQuery").prop("disabled", false)
        //     }
        // }
    }

    getQueryString() {
        let queryString;
        let target = $("#queryTargetSelect")
        let topic = $("#queryTargetTopic")
        let name = $("#queryTargetName")
        let fedSpecific = $("#queryFederateSpecific")

        if (target.prop('selectedIndex') > 0) {
            queryString = "?target=" + target.val()
        }

        if (topic.prop('selectedIndex') > 0 && !topic.attr('disabled')) {
            queryString += "&topic=" + topic.val()
        } else if (name.prop('selectedIndex') > 0 && !name.attr('disabled')
            && fedSpecific.prop('selectedIndex') > 0 && !fedSpecific.attr('disabled')) {
            queryString += "&name=" + name.val() + "&fedSpec=" + fedSpecific.val()
        }
        console.log("queryString = " + queryString)
        return queryString;
    }

    renderQuery(data) {
        let queryResponseWindow = $("#queryResponseWindow")

        let queryHeader;
        let target = $("#queryTargetSelect")
        let topic = $("#queryTargetTopic")
        let name = $("#queryTargetName")
        let fedSpecific = $("#queryFederateSpecific")

        if (target.prop('selectedIndex') > 0) {
            queryHeader = target.val()
        }

        if (topic.prop('selectedIndex') > 0 && !topic.attr('disabled')) {
            queryHeader += "/" + topic.val()
        } else if (name.prop('selectedIndex') > 0 && !name.attr('disabled')
            && fedSpecific.prop('selectedIndex') > 0 && !fedSpecific.attr('disabled')) {
            queryHeader += "/" + name.val() + "/" + fedSpecific.val()
        }

        let queryResponseTemplate = "<div class='helics-query-response-block'>" +
            "<h3>" + queryHeader + "</h3>" +
            "<code>" + data + "</code>" +
            "</div>"
        queryResponseWindow.append(queryResponseTemplate)
    }

    renderError(data) {
        let queryResponseWindow = $("#queryResponseWindow")

        let queryHeader;
        let target = $("#queryTargetSelect")
        let topic = $("#queryTargetTopic")
        let name = $("#queryTargetName")
        let fedSpecific = $("#queryFederateSpecific")

        if (target.prop('selectedIndex') > 0) {
            queryHeader = target.val()
        }

        if (topic.prop('selectedIndex') > 0 && !topic.attr('disabled')) {
            queryHeader += "/" + topic.val()
        } else if (name.prop('selectedIndex') > 0 && !name.attr('disabled')
            && fedSpecific.prop('selectedIndex') > 0 && !fedSpecific.attr('disabled')) {
            queryHeader += "/" + name.val() + "/" + fedSpecific.val()
        }

        let queryResponseTemplate = "<div class='helics-query-response-block'>" +
            "<h3>" + queryHeader + "</h3>" +
            "<p>An error occurred, preventing data return. Verify a queryable federation is running and try again.</p>" +
            "</div>"
        queryResponseWindow.append(queryResponseTemplate)
    }

    getRequest(endpoint, callback = null, error_callback = null, query_string = null) {
        let query = "/api/" + endpoint;
        if (query_string !== null)
            query += query_string;
        let messagePackage = {
            url: query,
            type: "GET"
        }
        return $.ajax(messagePackage)
            .done(function (response) {
                if (callback !== null) callback(response);
            })
            .fail(function (response) {
                console.log(response);
                if (error_callback !== null) error_callback(response)
            });
    }
}