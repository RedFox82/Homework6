import {LightningElement, api, wire} from 'lwc';
import {refreshApex} from '@salesforce/apex';
import getContactsByAccountId from '@salesforce/apex/ContactController.getContactsByAccountId';
import addContact from '@salesforce/apex/ContactController.addContact';
import PlatformShowToastEvent, {ShowToastEvent} from "lightning/platformShowToastEvent";



export default class RelatedContacts extends LightningElement {
    @api recordId;
    showForm = false;

    @wire(getContactsByAccountId, {accountId: '$recordId'})
    contacts;

    addContact() {
        this.showForm = !this.showForm;
    }

    handleNameInput(event) {
        this.LastName = event.target.value;
    }

    createContact() {
        addContact({accountId: this.recordId, lastName: this.LastName})
            .then(result => {
                this.addContact();
                this.LastName = null;
                refreshApex(this.contacts);
            })
            .catch(error => {
                console.log(error);
                const event = new ShowToastEvent ({
                    title: 'Ooops!',
                    message:'Contact not created!',
                    variant: 'error',
                });
                this.dispatchEvent(event);
            })
    }

}
