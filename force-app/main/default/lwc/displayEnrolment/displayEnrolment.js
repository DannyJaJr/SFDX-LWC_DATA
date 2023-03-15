import { LightningElement, wire } from 'lwc';
import { getListUi } from 'lightning/uiListApi';
import ENROLLMENT_OBJECT from '@salesforce/schema/Enrollment__c';
import CONTACT_FIELD from '@salesforce/schema/Enrollment__c.Contact__c';
import COURSE_VERSION_FIELD from '@salesforce/schema/Enrollment__c.Course_Version__c';
import STATUS_FIELD from '@salesforce/schema/Enrollment__c.Status__c';
import SYNC_STATUS_FIELD from '@salesforce/schema/Enrollment__c.Sync_Status__c';

const COLUMNS = [
    { label: 'Contact', fieldName: CONTACT_FIELD.fieldApiName, type: 'text' },
    { label: 'Course Version', fieldName: COURSE_VERSION_FIELD.fieldApiName, type: 'text' },
    { label: 'Status', fieldName: STATUS_FIELD.fieldApiName, type: 'text' },
    { label: 'Sync Status', fieldName: SYNC_STATUS_FIELD.fieldApiName, type: 'text' },
    {
        type: 'action',
        typeAttributes: { rowActions: [{ label: 'Edit', name: 'edit' }] }
    }
];

export default class DisplayEnrolment extends LightningElement {
    columns = COLUMNS;
    enrollments = [];

    @wire(getListUi, {
        objectApiName: ENROLLMENT_OBJECT,
        listViewApiName: 'All'
    })
    wiredEnrollments({ error, data }) {
        if (data) {
            this.enrollments = data.records.records.map(record => ({
                Id: record.id,
                ...record.fields
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
}
