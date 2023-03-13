({ configMap: {
    "string": { 
        componentDef: "lightning:input", 
        attributes: { 
            "class" : "slds-input container",
        } 
    },
    "checkbox": { 
        componentDef: "lightning:input", 
        attributes: { 
            "class" : "slds-checkbox__label"
        } 
    },
    "button" : {
        componentDef : "lightning:button",
        attributes : {
            "variant" : "brand",
            "iconName" : "utility:automate",
            "label" : "Submit"
        }
    },
    "picklist" : {
        componentDef : "ui:inputSelect",
        attributes : {
            "class" : "slds-select slds-select_container container"
        }
    },
    "multipicklist" : {
        componentDef : "lightning:dualListbox",
        attributes : {
            "sourceLabel" : "Available Options",
            "selectedLabe" : "Selected Options",
            "readonly" : false
        }
    },
    "textarea" : {
        componentDef : "lightning:textarea",
        attributes : {
            "class" : ""
        }
    },
} ,
  onFieldSetChange : function(component, event, helper){
      var self = this;
      var FiledSetMember = component.get('c.getFieldSetMember');
      FiledSetMember.setParams({
      });
      FiledSetMember.setCallback(this, function(response){
          var state = response.getState();
          if(component.isValid() && (state === 'SUCCESS' || state === 'DRAFT')){
              var fieldSetMember = JSON.parse(response.getReturnValue());
              self.createForm(component, event, helper, fieldSetMember);
          }else if(state==='INCOMPLETE'){
              console.log('User is Offline System does not support drafts '
                          + JSON.stringify(response.getError()));
          }else if(state ==='ERROR'){
              console.log(response.getError());
          }else{
              
          }
      });
      FiledSetMember.setStorable();
      $A.enqueueAction(FiledSetMember);
  },
  createForm : function(component, event, helper, fieldSetMember){
      // Create a map with availale inputs and according to this use the global map.
      var lightningInputMap = new Map();
      lightningInputMap.set('string','string');
      lightningInputMap.set('checkbox','checkbox');
      lightningInputMap.set('date','date');
      lightningInputMap.set('datetime','datetime');
      lightningInputMap.set('email','email');
      lightningInputMap.set('file','file');
      lightningInputMap.set('password','password');
      lightningInputMap.set('search','search');
      lightningInputMap.set('tel','tel');
      lightningInputMap.set('url','url');
      lightningInputMap.set('number','number');
      lightningInputMap.set('radio','radio');
      
      // list of components to create and put into the component body..
      var inputDesc = [];
      var config = null;
      
      /*
         * parse the FieldSet members and then create the members dynamically 
         * and put those components into the component.
         */ 
      for(var i=0; i < fieldSetMember.length; i++){
          var objectName = component.getReference("v.sObjectName");
          if(lightningInputMap.has(fieldSetMember[i].fieldType.toLowerCase())){
              config = JSON.parse(
                  JSON.stringify(this.configMap['string'])
              ); 
              if(config){
                  config.attributes.label = fieldSetMember[i].fieldLabel;
                  config.attributes.type = fieldSetMember[i].fieldType;
                  config.attributes.required = 
                      fieldSetMember[i].isRequired || fieldSetMember[i].isDBRequired;
                  config.attributes.value = 
                      component.getReference('v.sObjectName.' + fieldSetMember[i].fieldAPIName);
                  inputDesc.push([
                      config.componentDef,
                      config.attributes
                  ]);
              }
          }else{
              if(fieldSetMember[i].fieldType.toLowerCase() === 'integer'){
                  config = JSON.parse(
                      JSON.stringify(this.configMap['string'])
                  );
                  config.attributes.label = fieldSetMember[i].fieldLabel;
                  config.attributes.type = 'number';
                  config.attributes.required = 
                      fieldSetMember[i].isRequired || fieldSetMember[i].isDBRequired;
                  config.attributes.value = 
                      component.getReference('v.sObjectName.' + fieldSetMember[i].fieldAPIName);
                  inputDesc.push([
                      config.componentDef,
                      config.attributes
                  ]);
              }else if(fieldSetMember[i].fieldType.toLowerCase() === 'phone'){
                  config = JSON.parse(
                      JSON.stringify(this.configMap['string'])
                  );
                  config.attributes.label = fieldSetMember[i].fieldLabel;
                  config.attributes.type = 'tel';
                  config.attributes.required = 
                      fieldSetMember[i].isRequired || fieldSetMember[i].isDBRequired;
                  config.attributes.value = 
                      component.getReference('v.sObjectName.' + fieldSetMember[i].fieldAPIName);
                  
                  inputDesc.push([
                      config.componentDef,
                      config.attributes
                  ]);
              }else if(fieldSetMember[i].fieldType.toLowerCase() === 'textarea'){
                  config = JSON.parse(
                      JSON.stringify(this.configMap['textarea'])
                  );
                  config.attributes.label = fieldSetMember[i].fieldLabel;
                  config.attributes.name = fieldSetMember[i].fieldLabel;
                  
                  config.attributes.required = 
                      fieldSetMember[i].isRequired || fieldSetMember[i].isDBRequired;
                  config.attributes.value = 
                      component.getReference('v.sObjectName.' + fieldSetMember[i].fieldAPIName);
                  
                  inputDesc.push([
                      config.componentDef,
                      config.attributes
                  ]);
              }else if(fieldSetMember[i].fieldType.toLowerCase() === 'picklist'){
                  config = JSON.parse(
                      JSON.stringify(this.configMap['picklist'])
                  );
                  config.attributes.label = fieldSetMember[i].fieldLabel;
                  config.attributes.name = fieldSetMember[i].fieldLabel;
                  var pickList = fieldSetMember[i].pickListValues;
                  var options = [];
                  for(var k=0; k<pickList.length; k++){
                      if(pickList[k].active){
                          options.push({
                              value : pickList[k].value,
                              label : pickList[k].label
                          });
                      }
                  }
                  config.attributes.options = options;
                  config.attributes.required = 
                      fieldSetMember[i].isRequired || fieldSetMember[i].isDBRequired;
                  config.attributes.value = 
                      component.getReference('v.sObjectName.' + fieldSetMember[i].fieldAPIName);
                  
                  inputDesc.push([
                      config.componentDef,
                      config.attributes
                  ]);
              }else if(fieldSetMember[i].fieldType.toLowerCase() === 'multipicklist'){
                  config = JSON.parse(
                      JSON.stringify(this.configMap['multipicklist'])
                  );
                  config.attributes.label = fieldSetMember[i].fieldLabel;
                  config.attributes.name = fieldSetMember[i].fieldLabel;
                  var pickList = fieldSetMember[i].pickListValues;
                  var options = [];
                  for(var k=0; k<pickList.length; k++){
                      if(pickList[k].active){
                          options.push({
                              value : pickList[k].value,
                              label : pickList[k].label
                          });
                      }
                  }
                  config.attributes.options = options;
                  config.attributes.required = 
                      fieldSetMember[i].isRequired || fieldSetMember[i].isDBRequired;
                  config.attributes.value = 
                      component.getReference('v.sObjectName.' + fieldSetMember[i].fieldAPIName);
                  /*
                    inputDesc.push([
                        config.componentDef,
                        config.attributes
                    ]);*/
              }
          }
      }
      var newConfig = JSON.parse(
          JSON.stringify(this.configMap['button'])
      );
      newConfig.attributes.onclick = component.getReference("c.handlePress");
      
      inputDesc.push([
          newConfig.componentDef,
          newConfig.attributes
      ]);
      
      $A.createComponents(inputDesc,
                          function(components, status, errorMessage){
                              if (status === "SUCCESS") {
                                  var form = [];
                                  for(var j=0; j < components.length; j++){
                                      form.push(components[j]);
                                  }
                                  component.set("v.theForm", form);
                              }else if (status === "INCOMPLETE") {
                                  console.log("No response from server or client is offline.");
                              }else if (status === "ERROR") {
                                  console.log("Error: " + errorMessage);
                                  console.log(errorMessage);
                              }
                          }
                         );
  },
  onUpserObject : function(component, event, helper){
       component.set("v.isLoaded",true);  
      var upsertObject = component.get('c.doUpsertObjects');
      debugger;
      
      upsertObject.setParams({
          "objectData" :  JSON.stringify(component.get('v.sObjectName')),
           "vId" : component.get('v.voteId')
      });
      
      upsertObject.setCallback(this, function(response){
          var state = response.getState();
          if(component.isValid() && (state === 'SUCCESS' || state === 'DRAFT')){
              var cmpEvent = component.getEvent("componentRefresh");
              cmpEvent.fire();
              //this.showToast('SUCCESS','Votes Recorded !!','SUCCESS');
          }else if(state==='INCOMPLETE'){
              console.log('User is Offline System does not support drafts '
                          + JSON.stringify(response.getError()));
          }else if(state ==='ERROR'){
              console.log(response.getError());
          }else{
              console.log('Unknown Error While making DML'
                          + JSON.stringify(response.getError()));
          }
      });
      $A.enqueueAction(upsertObject);
  },
  showToast: function(msgtitle,msg,type){
      var toastEvent = $A.get("e.force:showToast");
      toastEvent.setParams({
          title : msgtitle,
          message: msg,
          duration:' 5000',
          type: type,
      });
      toastEvent.fire();
  }
 })