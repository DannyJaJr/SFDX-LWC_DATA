({
  doInit: function (component, event, helper) {
    var action = component.get("c.getRenewalHistory");
    action.setParams({});
    action.setCallback(this, function (response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        var storeResponse = response.getReturnValue();
        if (storeResponse.length > 0) {
          //component.set("v.Message",storeResponse);
          // component.set("v.renewalHistory", response.getReturnValue());

          component.set(
            "v.totalPages",
            Math.ceil(
              response.getReturnValue().length / component.get("v.pageSize")
            )
          );
          component.set("v.TotalRecord", response.getReturnValue().length);
          component.set("v.allData", response.getReturnValue());
          component.set("v.renewalfirstRecord", response.getReturnValue()[0]);
          console.log(JSON.stringify(component.get("v.renewalfirstRecord")));
          console.log("response" + JSON.stringify(response.getReturnValue()));
          component.set("v.currentPageNumber", 1);
          helper.buildData(component, helper);
        }
      } else {
        console.log("component Error !!!!");
      }
    });
    $A.enqueueAction(action);
  },
  onNext: function (component, event, helper) {
    var pageNumber = component.get("v.currentPageNumber");
    component.set("v.currentPageNumber", pageNumber + 1);
    helper.buildData(component, helper);
    var pagesize = component.get("v.pageSize");
    var Ind = component.get("v.Index");
    component.set("v.Index", Ind + 1 + pagesize);
  },

  onPrev: function (component, event, helper) {
    var pageNumber = component.get("v.currentPageNumber");
    component.set("v.currentPageNumber", pageNumber - 1);

    helper.buildData(component, helper);
    var pagesize = component.get("v.pageSize");
    var Ind = component.get("v.Index");
    component.set("v.Index", Ind - 1 - pagesize);
  },

  processMe: function (component, event, helper) {
    component.set("v.currentPageNumber", parseInt(event.target.name));
    helper.buildData(component, helper);
  },

  onFirst: function (component, event, helper) {
    component.set("v.currentPageNumber", 1);
    helper.buildData(component, helper);
    var Ind = component.get("v.Index");
    component.set("v.Index", 0);
  },

  onLast: function (component, event, helper) {
    component.set("v.currentPageNumber", component.get("v.totalPages"));
    helper.buildData(component, helper);
    var TotalRec = component.get("v.TotalRecord");
    var Ind = component.get("v.Index");
    component.set("v.Index", TotalRec - 1);
    console.log(JSON.stringify(component.get("v.TotalRecord")));
  }
});