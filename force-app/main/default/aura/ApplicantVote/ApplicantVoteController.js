({
    onInit : function(component, event, helper) {
         component.set("v.scholar",component.get("v.sRecord")[0]);
         helper.onFieldSetChange(component, event, helper);
    },
    handlePress : function(component, event, helper) {
        var objectName = component.get('v.sObjectName');
        helper.onUpserObject(component, event, helper);
    },
})