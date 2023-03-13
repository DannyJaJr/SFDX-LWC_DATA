/* eslint-disable no-debugger */
/* eslint-disable no-unused-vars */
({
  onload: function (component, event, helper) {
    var action = component.get("c.getProfileData");
    action.setCallback(this, function (response) {
      var state = response.getState();
      debugger;
      if (state === "SUCCESS") {
        var StoreResponse = response.getReturnValue();
        if (StoreResponse) {
          component.set("v.parentId", StoreResponse.Id);
          component.set("v.contactData", StoreResponse);
        }
      }
    });
    $A.enqueueAction(action);
  }
});