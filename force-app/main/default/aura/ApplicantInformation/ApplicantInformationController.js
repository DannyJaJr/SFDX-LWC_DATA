/* eslint-disable no-empty */
/* eslint-disable no-console */
/* eslint-disable no-debugger */
/* eslint-disable no-unused-vars */

({
  getApplicantInformation: function (component, event, helper) {
    var action = component.get("c.getScholarRecord");
    action.setParams({
      sid: component.get("v.sId")
    });
    action.setCallback(this, function (response) {
      var state = response.getState();
      var res = response.getReturnValue();
      if (state === "SUCCESS") {
        component.set("v.sRecord", res);

        if (res.Votes__r[0]) component.set("v.voteId", res.Votes__r[0].Id);
        debugger;
        component.set("v.showComponent", true);
      } else if (state === "ERROR") {
      } else {
        console.log("Error Blogs !!!");
      }
    });

    $A.enqueueAction(action);
  }
});