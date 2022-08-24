
import {LightningElement, api} from 'lwc';
import {deleteRecord} from 'lightning/uiRecordApi';
import {ShowToastEvent} from "lightning/platformShowToastEvent";

export default class Diary extends LightningElement {
    @api diary;


    delContact(event) {
            deleteRecord(this.diary.Id)
                .then(() => {
                    this.dispatchEvent(new CustomEvent('delete'));
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Note of diary have been deleted',
                            variant: 'success'
                        })
                    );
                })
                .catch(error => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error deleting record',
                            message: error.body.message,
                            variant: 'error'
                        })
                    );
                });
        }
}
