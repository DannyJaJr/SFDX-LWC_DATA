import { LightningElement, api, wire } from 'lwc';
import { getListUi } from 'lightning/uiListApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getRecord, createRecord } from 'lightning/uiRecordApi';
//Importing Enrollment fields
import ENROLLMENT_OBJECT from '@salesforce/schema/Enrollment__c';
import ENROLLMENT_NAME from '@salesforce/schema/Enrollment__c.Name';
import CONTACT_FIELD from '@salesforce/schema/Enrollment__c.Contact__c';
import COURSE_VERSION_FIELD from '@salesforce/schema/Enrollment__c.Course_Version__c';
import STATUS_FIELD from '@salesforce/schema/Enrollment__c.Status__c';
import SYNC_STATUS_FIELD from '@salesforce/schema/Enrollment__c.Sync_Status__c';
//importing contact full name
import FULL_NAME_FIELD from '@salesforce/schema/Contact.Full_Name__c';
//importing course version name
import COURSE_VERSION_NAME_FIELD from '@salesforce/schema/Course_Version__c.Name';


//Enrolemnt columns fields data
const COLUMNS = [
    { label: 'Name', fieldName: ENROLLMENT_NAME.fieldApiName, type: 'Auto Number' },
    { label: 'Contact', fieldName: CONTACT_FIELD.fieldApiName, type: 'Lookup(Contact)' },
    { label: 'Course Version', fieldName: COURSE_VERSION_FIELD.fieldApiName, type: 'Lookup(Course Version)' },
    { label: 'Status', fieldName: STATUS_FIELD.fieldApiName, type: 'Picklist' },
    { label: 'Sync Status', fieldName: SYNC_STATUS_FIELD.fieldApiName, type: 'Picklist' },
    {
        type: 'action',
        typeAttributes: { rowActions: [{ label: 'Edit', name: 'edit' }] }
    }
];

const ENROLLMENT_FIELDS = [
    ENROLLMENT_NAME,
    CONTACT_FIELD,
    COURSE_VERSION_FIELD,
    STATUS_FIELD,
    SYNC_STATUS_FIELD
];

/**Define the JavaScript function named "createNewEnrollment". 
 * This function will use the Lightning Data Service to retrieve the necessary
 *  record data, and then create a new enrollment record using the retrieved
 *  data: 
 **/

//contact : Obi-Wan Kenobi
//course version : Healthy Habits - Fall 2023
export default class CreateEnrollment extends LightningElement {
    //Retieve Enrollment data
    columns = COLUMNS;

    enrollments = [];


    @wire(getListUi, {
        objectApiName: ENROLLMENT_OBJECT,
        listViewApiName: 'All',
        fields: [...ENROLLMENT_FIELDS, 'Contact__r.' + FULL_NAME_FIELD.fieldApiName, 'Course_Version__r.' + COURSE_VERSION_NAME_FIELD.fieldApiName]
    })
    wiredEnrollments({ error, data }) {
        console.log("Yes ther is data");
        if (data) {
            this.enrollments = data.records.records.map(record =>({
                Id: record.id,
                Name: record.fields.Name ? record.fields.Name.value : '',
                Contact__c: record.fields.Contact__c ? record.fields.Contact__c.value : '',
                Contact__r: record.fields.Contact__c ? record.fields.Contact__c.displayValue : '',
                Course_Version__c: record.fields.Course_Version__c ? record.fields.Course_Version__c.value : '',
                Course_Version__r: record.fields.Course_Version__c ? record.fields.Course_Version__c.displayValue : '',
                Status__c: record.fields.Status__c ? record.fields.Status__c.value : '',
                Sync_Status__c: record.fields.Sync_Status__c ? record.fields.Sync_Status__c.value : ''
            }));
        } else if (error) {
            console.error(error);
        }
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch (actionName) {
            case 'edit':
                // Handle edit action
                break;
            default:
                break;
        }
    }










    @api recordId;

    @wire(getObjectInfo, { objectApiName: ENROLLMENT_OBJECT })
    enrollmentObjectInfo;

    @wire(getRecord, { recordId: '$recordId', fields: [CONTACT_FIELD] })
    contactRecord;

    @wire(getRecord, { recordId: '$recordId', fields: [COURSE_VERSION_FIELD] })
    courseVersionRecord;

    createNewEnrollment() {
        const enrollmentRecord = {
            [CONTACT_FIELD.fieldApiName]: this.contactRecord.data.fields[FULL_NAME_FIELD.fieldApiName].value,
            [COURSE_VERSION_FIELD.fieldApiName]: this.courseVersionRecord.data.fields[COURSE_VERSION_NAME_FIELD.fieldApiName].value,
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





