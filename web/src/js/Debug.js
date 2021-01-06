export default class {
    debugSetup() {
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
        if ($('#queryTargetSelect').val() === "Named Federate") {
            this.visibilityControl('.helics-federate-selector', true);
        } else {
            this.visibilityControl('.helics-core-selector', true);

        }
    }

    visibilityControl(tag, visible){
        if(visible) {
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
        $.each($(".helics-debug-dropdown"), function(index, value){
            if(!$(value).attr("disabled") && value.selectedIndex > 0){
                enableButton.push(true);
            } else if(!$(value).attr("disabled")) {
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

    getRequest(endpoint, callback = null, value = null) {
        let messagePackage = {
            url: "/api/" + endpoint,
            // type: "PUT",
            type: "GET",
            // dataType: "json",
            // data: []
            error: function (response) {
                console.log(response);
            }
        }
        if (callback !== null) messagePackage.success = callback;
        if (value !== null) messagePackage.data = value;

        return $.ajax(messagePackage);
    }
}