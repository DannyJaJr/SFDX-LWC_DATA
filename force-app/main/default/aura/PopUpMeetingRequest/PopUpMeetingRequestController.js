({
    cancel : function(component, event, helper) {
        component.set("v.hideModal",false);
        
    },
    handleSubmit : function(component, event, helper){
        
        var eventFields = event.getParam("fields");
        console.log(JSON.stringify(eventFields));
        component.find('myform').submit(eventFields);
        
    },
    handleSuccess :function(component, event, helper){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The record has been saved successfully."
        });
        toastEvent.fire();
        component.set("v.hideModal",false); 
        var payload = event.getParams().response;
        var meetingRequestId = payload.id;
        console.log(JSON.stringify(payload.id));
        var action =component.get('c.concatContactId');
        action.setParams({ meetingRecordId : meetingRequestId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('Success');
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        
        $A.enqueueAction(action);
    },
    
 handleOnError : function(component, event, helper) {
    console.log('Error Here' +event); 
    var errors = event.getParams();
    console.log("Error Response", JSON.stringify(errors)); 
    var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
        "title": "Error!",
        "message": "Error."
    });
    toastEvent.fire();
}
})