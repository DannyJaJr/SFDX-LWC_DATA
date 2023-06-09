/* eslint-disable no-alert */
/* eslint-disable no-console */
/* eslint-disable no-unused-vars */

({
  MAX_FILE_SIZE: 4500000,
  CHUNK_SIZE: 4500000,

  uploadHelper: function (component, event) {
    component.set("v.showLoadingSpinner", true);
    var fileInput = component.find("fileId").get("v.files");
    var file = fileInput[0];
    var self = this;
    if (file.size > self.MAX_FILE_SIZE) {
      component.set("v.showLoadingSpinner", false);
      component.set(
        "v.fileName",
        "Alert : File size cannot exceed " +
          self.MAX_FILE_SIZE +
          " bytes.\n" +
          " Selected file size: " +
          file.size
      );
      return;
    }

    var objFileReader = new FileReader();
    objFileReader.onload = $A.getCallback(function () {
      var fileContents = objFileReader.result;
      var base64 = "base64,";
      var dataStart = fileContents.indexOf(base64) + base64.length;
      fileContents = fileContents.substring(dataStart);
      self.uploadProcess(component, file, fileContents);
      var cmpEvent = component.getEvent("ImageRender");
      cmpEvent.fire();
    });

    objFileReader.readAsDataURL(file);
  },

  uploadProcess: function (component, file, fileContents) {
    var startPosition = 0;
    var endPosition = Math.min(
      fileContents.length,
      startPosition + this.CHUNK_SIZE
    );
    this.uploadInChunk(
      component,
      file,
      fileContents,
      startPosition,
      endPosition,
      ""
    );
  },

  uploadInChunk: function (
    component,
    file,
    fileContents,
    startPosition,
    endPosition,
    attachId
  ) {
    // call the apex method 'saveChunk'
    var getchunk = fileContents.substring(startPosition, endPosition);
    var action = component.get("c.saveChunk");
    action.setParams({
      parentId: component.get("v.parentId"),
      fileName: file.name,
      base64Data: encodeURIComponent(getchunk),
      fileId: attachId
    });

    action.setCallback(this, function (response) {
      attachId = response.getReturnValue();
      var state = response.getState();
      if (state === "SUCCESS") {
        startPosition = endPosition;
        endPosition = Math.min(
          fileContents.length,
          startPosition + this.CHUNK_SIZE
        );

        if (startPosition < endPosition) {
          this.uploadInChunk(
            component,
            file,
            fileContents,
            startPosition,
            endPosition,
            attachId
          );
        } else {
          component.set("v.showLoadingSpinner", false);
          var toastEvent = $A.get("e.force:showToast");
          toastEvent.setParams({
            title: "Success!",
            message: "Image has been updated succesfully."
          });
          toastEvent.fire();

          component.set("v.ShowImageModal", false);
        }
        // handel the response errors
      } else if (state === "INCOMPLETE") {
        alert("From server: " + response.getReturnValue());
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
    // enqueue the action
    $A.enqueueAction(action);
  }
});