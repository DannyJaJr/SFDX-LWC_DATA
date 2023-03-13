/* eslint-disable no-debugger */
/* eslint-disable no-unused-vars */
({
  doInit: function (component, event, helper) {
    helper.onload(component, event);
  },
  UpdatePicture: function (component, event, helper) {
    var img = component.find("imgOver");
    $A.util.addClass(img, "colorImg");
  },
  resetImg: function (component, event, helper) {
    var img = component.find("imgOver");
    $A.util.removeClass(img, "colorImg");
  },
  uploadpicWizard: function (component, event, helper) {
    debugger;
  },
  cancel: function (component, event, helper) {
    component.set("v.ShowModal", false);
  },
  handleSubmit: function (component, event, helper) {
    var eventFields = event.getParam("fields");
    component.find("myform").submit(eventFields);
    component.set("v.ShowSpinner", true);
  },
  handleSuccess: function (component, event, helper) {
    var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
      title: "Success!",
      message: "The record has been Update successfully."
    });
    toastEvent.fire();
    component.set("v.ShowSpinner", false);
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
  EditProfile: function (component, event, helper) {
    component.set("v.ShowModal", true);
  },
  UpdateImage: function (component, event, helper) {
    component.set("v.ChangeImage", true);
    component.set("v.ShowImageModal", true);
  },
  RenderImage: function (component, event, helper) {
    helper.onload(component, event, helper);
  }
});