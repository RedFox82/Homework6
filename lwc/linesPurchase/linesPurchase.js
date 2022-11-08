import {LightningElement, api} from 'lwc';

export default class LinesPurchase extends LightningElement {
@api lines;

    delItem(event){
        const lineKey = String(event.target.value);
        this.dispatchEvent(
            new CustomEvent('delete', { detail: lineKey})
        );
    }

}