/* eslint-disable no-console */
/* eslint-disable no-debugger */
/* eslint-disable no-unused-vars */

({
  ShowPopUp: function (component, event, helper) {
    component.set("v.ShowPop", true);
    component.set("v.hideModal", true);
  },
  doInit: function (component, event, helper) {
    debugger;
    var action = component.get("c.onInit");
    action.setParams({});
    action.setCallback(this, function (response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        var storeResponse = response.getReturnValue();
        if (storeResponse.length > 0) {
          //component.set("v.Message",storeResponse);
          component.set("v.meetingHistory", response.getReturnValue());
          console.log("test" + JSON.stringify(response.getReturnValue()));
        }
      } else {
        console.log("component Error !!!!");
      }
    });
    $A.enqueueAction(action);
  }
});