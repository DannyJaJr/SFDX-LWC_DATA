/* eslint-disable no-console */
/* eslint-disable no-empty */
/* eslint-disable no-unused-vars */

({
  doInit: function (component, event, helper) {
    component.set("v.isLoaded", false);
    component.set("v.showAcademcis", false);
    var action = component.get("c.getVotes");
    action.setParams({});

    action.setCallback(this, function (response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        var retResponse = response.getReturnValue();
        component.set("v.scholarRecord", retResponse);
        component.set("v.openVotes", retResponse.openvotes);
        component.set("v.closedVotes", retResponse.closedVotes);
        component.set("v.votingFor", retResponse.votingFor);
        component.set("v.academicsList", retResponse.academicsList);
        component.set("v.financeList", retResponse.financeList);
        component.set("v.recommendationList", retResponse.recommendationList);
        component.set("v.socialList", retResponse.socialList);
        component.set("v.reviewList", retResponse.reviewsList);
        component.set("v.voteList", retResponse.voteList);
      } else if (state === "ERROR") {
      } else {
        console.log("Error Blogs !!!");
      }
      component.set("v.isLoaded", true);
    });

    $A.enqueueAction(action);
  },
  doSomething: function (component, event, helper) {
    component.set("v.showAcademcis", false);
    var sId = event.srcElement.name;
    component.set("v.sId", sId);
    component.set("v.showAcademcis", true);
    component.set("v.showAcademcis", true);
  }
});