/* eslint-disable no-empty */
/* eslint-disable no-console */
/* eslint-disable no-unused-vars */

({
  onload: function (component, event, helper) {
    var action = component.get("c.conData");
    action.setCallback(this, function (response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        if (response.getReturnValue().con.Name != null) {
          console.log(JSON.stringify(response.getReturnValue()));
          component.set("v.con", response.getReturnValue().con);
          component.set("v.showSpinner", false);
          component.set("v.parentId", response.getReturnValue().con.Id);
          component.set("v.ShowDetails", true);
          component.set(
            "v.ContentId",
            response.getReturnValue().contentVersionId
          );
          console.log("comp" + JSON.stringify(component.get("v.parentId")));
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