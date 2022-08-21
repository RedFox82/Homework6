
import {LightningElement, api} from 'lwc';

export default class Person extends LightningElement {
    @api contact;
    showDetail = false;

    contactClick() {
        this.showDetail = !this.showDetail;
    }


}