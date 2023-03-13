/* eslint-disable no-empty */
/* eslint-disable no-console */
/* eslint-disable guard-for-in */
/* eslint-disable no-unused-vars */

({
  doinit: function (component, event, helper) {
    var action = component.get("c.Renewallink");

    action.setCallback(this, function (response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        if (response.getReturnValue().length >= 0) {
          for (var i in response.getReturnValue()) {
            console.log(
              JSON.stringify(
                response.getReturnValue()[i].Scholar_Renewal_Link__c
              )
            );
            component.set(
              "v.RenewalLink",
              response.getReturnValue()[i].Scholar_Renewal_Link__c
            );
          }
        }
      } else if (state === "INCOMPLETE") {
      } else if (state === "ERROR") {
        var errors = response.getError();
        if (errors) {
          if (errors[0] && errors[0].message) {
            console.log("Error message: " + errors[0].message);
          }
        } else {
          console.log("Unknown error");
        }
      }
    });

    $A.enqueueAction(action);
  }
});