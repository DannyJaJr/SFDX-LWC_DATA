/* eslint-disable no-console */
/* eslint-disable no-unused-vars */

({
  doinit: function (component, event, helper) {
    helper.onload(component, event, helper);
  },
  cancel: function (component, event, helper) {
    component.set("v.ShowModal", false);
  },
  handleSubmit: function (component, event, helper) {
    var eventFields = event.getParam("fields");
    component.find("myform").submit(eventFields);
  },
  handleSuccess: function (component, event, helper) {
    var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
      title: "Success!",
      message: "The record has been Update successfully."
    });
    toastEvent.fire();
    helper.onload(component, event);
    component.set("v.ShowModal", false);
  },
  handleOnError: function (component, event, helper) {
    var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
      title: "Error!",
      message: "An Error has been occurred."
    });
    toastEvent.fire();
  },
  EditContact: function (component, event, helper) {
    component.set("v.ShowModal", true);
    console.log(JSON.stringify(component.get("v.ShowModal")));
  },
  UpdateImage: function (component, event, helper) {
    component.set("v.ChangeImage", true);
    component.set("v.ShowImageModal", true);
  },
  RenderImage: function (component, event, helper) {
    helper.onload(component, event, helper);
  }
});