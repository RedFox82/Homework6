import {LightningElement, api, wire} from 'lwc';
import {refreshApex} from '@salesforce/apex';
import getDiariesByContactId from '@salesforce/apex/DiaryController.getDiariesByContactId';
import addNote from '@salesforce/apex/DiaryController.addNote';
import {ShowToastEvent} from "lightning/platformShowToastEvent";



export default class DiaryList extends LightningElement {
    @api recordId;
    showForm = false;
    Note = null;

    @wire(getDiariesByContactId, {contactId: '$recordId'})
    diaries;

    addNote() {
        this.showForm = !this.showForm;
    }

    handleDelete() {
        refreshApex(this.diaries);
    }

    handleNoteInput(event) {
        this.Note = event.target.value;
    }

    createNote() {
        if (this.Note !== null) {
            addNote({contactId: this.recordId, note: this.Note})
                .then(result => {
                    this.Note = null;
                    this.addNote();
                    refreshApex(this.diaries);
                })
                .catch(error => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error creating record',
                            message: error.body.message,
                            variant: 'error'
                        })
                    );
                });
        }
    }


}
