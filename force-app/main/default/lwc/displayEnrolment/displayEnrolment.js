import { LightningElement, wire } from 'lwc';
import { getListUi } from 'lightning/uiListApi';
import { createRecord } from 'lightning/uiRecordApi';
//Importing Enrollment fields
import ENROLLMENT_OBJECT from '@salesforce/schema/Enrollment__c';
import ENROLLMENT_NAME from '@salesforce/schema/Enrollment__c.Name';
import CONTACT_FIELD from '@salesforce/schema/Enrollment__c.Contact__c';
import COURSE_VERSION_FIELD from '@salesforce/schema/Enrollment__c.Course_Version__c';
import STATUS_FIELD from '@salesforce/schema/Enrollment__c.Status__c';
import SYNC_STATUS_FIELD from '@salesforce/schema/Enrollment__c.Sync_Status__c';
//importing contact full name
import FULL_NAME_FIELD from '@salesforce/schema/Contact.Name';
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
        typeAttributes: { rowActions: [{ label: 'Create', name: 'create' }] }
    }
];

const ENROLLMENT_FIELDS = [
    ENROLLMENT_NAME,
    CONTACT_FIELD,
    COURSE_VERSION_FIELD,
    STATUS_FIELD,
    SYNC_STATUS_FIELD
];



export default class CreateEnrollment extends LightningElement {
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
            this.enrollments = data.records.records.map(record => ({
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


    createNewEnrollment(contactId, courseVersionId) {
        const fields = {};
        fields[ENROLLMENT_NAME.fieldApiName] = ''; // Auto-number field will be populated automatically
        fields[CONTACT_FIELD.fieldApiName] = contactId;
        fields[COURSE_VERSION_FIELD.fieldApiName] = courseVersionId;
        fields[STATUS_FIELD.fieldApiName] = 'Pending Enrollment';
        fields[SYNC_STATUS_FIELD.fieldApiName] = 'Pending Enrollment';

        const recordInput = { apiName: ENROLLMENT_OBJECT.objectApiName, fields };
        createRecord(recordInput)
            .then((enrollment) => {
                console.log('New enrollment created with Id: ', enrollment.id);
                // Add the new enrollment to the list of enrollments displayed in the component
                this.enrollments = [...this.enrollments, {
                    Id: enrollment.id,
                    Name: enrollment.fields[ENROLLMENT_NAME.fieldApiName].value,
                    Contact__c: enrollment.fields[CONTACT_FIELD.fieldApiName].value,
                    Course_Version__c: enrollment.fields[COURSE_VERSION_FIELD.fieldApiName].value,
                    Status__c: enrollment.fields[STATUS_FIELD.fieldApiName].value,
                    Sync_Status__c: enrollment.fields[SYNC_STATUS_FIELD.fieldApiName].value
                }];
            })
            .catch((error) => {
                console.error('Error creating enrollment: ', error);
            });

    }


}






