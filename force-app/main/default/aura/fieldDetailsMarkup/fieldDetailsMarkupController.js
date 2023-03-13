/* eslint-disable no-unused-vars */

({
  onInit: function (component, event, helper) {
    var rec = component.get("v.sRecord")[0];
    var fields = component.get("v.fieldList");

    var detailMap = [];
    var detail = { label: "", value: "" };
    if (fields) {
      for (var i = 0; i < fields.length; i++) {
        var obj = Object.create(detail);
        obj.label = fields[i].fieldName;
        obj.value = rec[fields[i].fieldApiName];
        detailMap.push(obj);
      }
      component.set("v.scholars", detailMap);
    }
  }
});