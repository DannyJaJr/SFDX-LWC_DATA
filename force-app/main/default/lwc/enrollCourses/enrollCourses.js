import { LightningElement, api, wire } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getRecord } from 'lightning/uiRecordApi';

import ENROLLMENT_OBJECT from '@salesforce/schema/Enrollment__c';
import CONTACT_FIELD from '@salesforce/schema/Enrollment__c.Contact__c';
import COURSE_VERSION_FIELD from '@salesforce/schema/Enrollment__c.Course_Version__c';
import STATUS_FIELD from '@salesforce/schema/Enrollment__c.Status__c';
import SYNC_STATUS_FIELD from '@salesforce/schema/Enrollment__c.Sync_Status__c';
import FULL_NAME_FIELD from '@salesforce/schema/Contact.Full_Name__c';
import COURSE_VERSION_NAME_FIELD from '@salesforce/schema/Course_Version__c.Name';

import { createRecord } from 'lightning/uiRecordApi';




/**Define the JavaScript function named "createNewEnrollment". 
 * This function will use the Lightning Data Service to retrieve the necessary
 *  record data, and then create a new enrollment record using the retrieved
 *  data: 
 **/

//contact : Obi-Wan Kenobi
//course version : Healthy Habits - Fall 2023
export default class CreateEnrollment extends LightningElement {
    @api recordId;

    @wire(getObjectInfo, { objectApiName: ENROLLMENT_OBJECT })
    enrollmentObjectInfo;

    @wire(getRecord, { recordId: '$recordId', fields: [CONTACT_FIELD] })
    contactRecord;

    @wire(getRecord, { recordId: '$recordId', fields: [COURSE_VERSION_FIELD] })
    courseVersionRecord;

    createNewEnrollment() {
        // const enrollmentRecord = {
        //     [CONTACT_FIELD.fieldApiName]: this.contactRecord.data.fields[FULL_NAME_FIELD.fieldApiName].value,
        //     [COURSE_VERSION_FIELD.fieldApiName]: this.courseVersionRecord.data.fields[COURSE_VERSION_NAME_FIELD.fieldApiName].value,
        //     [STATUS_FIELD.fieldApiName]: 'Pending Enrollment',
        //     [SYNC_STATUS_FIELD.fieldApiName]: 'Pending Enrollment'
        // };

        const enrollmentRecord = {
            [CONTACT_FIELD.fieldApiName]: 'Obi-Wan Kenobi',
            [COURSE_VERSION_FIELD.fieldApiName]: 'Healthy Habits - Fall 2023',
            [STATUS_FIELD.fieldApiName]: 'Pending Enrollment',
            [SYNC_STATUS_FIELD.fieldApiName]: 'Pending Enrollment'
        };

        // Use the Lightning Data Service to create a new enrollment record

        createRecord({
            apiName: ENROLLMENT_OBJECT.objectApiName,
            fields: enrollmentRecord
        })
            .then(() => {
                // Reset the form
                this.contactRecord = null;
                this.courseVersionRecord = null;

                // Show a success message
                const toastEvent = new ShowToastEvent({
                    title: 'Success!',
                    message: 'Enrollment record created.',
                    variant: 'success'
                });
                this.dispatchEvent(toastEvent);
            })
            .catch(error => {
                // Show an error message
                const toastEvent = new ShowToastEvent({
                    title: 'Error!',
                    message: error.body.message,
                    variant: 'error'
                });
                this.dispatchEvent(toastEvent);
            });



    }
}

// //new data
// import { LightningElement, wire } from 'lwc';
// import { getPicklistValues } from 'lightning/uiObjectInfoApi';
// import INDUSTRY_FIELD from '@salesforce/schema/Account.Industry';

// export default class Example extends LightningElement {
//     @wire(getPicklistValues, { recordTypeId: '012000000000000AAA', fieldApiName: INDUSTRY_FIELD })
//     propertyOrFunction;
// }