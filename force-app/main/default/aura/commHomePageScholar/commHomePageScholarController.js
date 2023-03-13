/* eslint-disable no-console */
/* eslint-disable no-empty */
/* eslint-disable no-debugger */
/* eslint-disable no-unused-vars */

({
  doinit: function (component, event, helper) {
    var action = component.get("c.getScholarData");
    action.setCallback(this, function (response) {
      var state = response.getState();
      debugger;
      if (state === "SUCCESS") {
        component.set("v.Scholar", response.getReturnValue());
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