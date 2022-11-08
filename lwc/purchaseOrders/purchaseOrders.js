import {LightningElement, api, wire, track} from 'lwc';
import getProducts from '@salesforce/apex/PurchaseOrderController.getProducts';
import addLines from '@salesforce/apex/PurchaseOrderController.addLines';
import {ShowToastEvent} from "lightning/platformShowToastEvent";
import {CloseActionScreenEvent} from "lightning/actions";

export default class PurchaseOrders extends LightningElement {
    @track products;
    @wire(getProducts, {})
    wiredProduct({ error, data }) {
        if (data) {
            console.log('result => ', JSON.stringify(data));
            this.products = data.map((cls) => Object.assign({}, { label: cls.Name, value: cls.Id }));
        } else if (error) {
            this.error = error;
            console.error('error => ', error); // error handling
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error product list',
                    message: this.error.body.message,
                    variant: 'Error list'
                })
            );
        }
    }

    @api recordId;
    @track lines =[];

    Name = null;
    line_Id = null;
    line_Name = null;
    line_Quantity = null;
    index = 0;

    addItem() {
        if (this.line_Id && this.line_Quantity) {
            this.lines.push({key : this.index, Id: this.line_Id, Name: this.line_Name, Quantity: this.line_Quantity});
            this.index = this.index + 1;
            this.line_Id = null;
            this.line_Name = null;
            this.line_Quantity = null;
            const inp1 = this.template.querySelector('.inp1');
            if (inp1) {
                inp1.value = null;
            }
            const inp2 = this.template.querySelector('.inp2');
            if (inp2) {
                inp2.value = null;
            }

        } else {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error line item creation',
                    message: 'Name and quantity cannot be empty.',
                    variant: 'error'
                })
            );
        }
    }

    formClose() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    handleNameInput(event) {
        this.Name = event.target.value;
    }

    handleQuantity(event) {
        this.line_Quantity = event.target.value;
    }

    selectedCombo(event) {
        this.line_Id = event.detail.value;
        this.line_Name = event.target.options.find(opt => opt.value === event.detail.value).label;
    }

    createOrder() {
        if (this.Name !== null) {
            let item2 = {};
            let item = {};
            for (let i = 0; i < this.lines.length; i++) {
                let ind = String(this.lines[i].Id.valueOf());
                if (item[ind] === undefined) {
                    item2[Number(this.lines[i].key.valueOf())] = Number(this.lines[i].Quantity.valueOf());
                    item[ind] = item2;
                    item2 = {};
                } else {
                    item2 = item[ind];
                    item2[Number(this.lines[i].key.valueOf())] = Number(this.lines[i].Quantity.valueOf());
                    item[ind] = item2;
                    item2 = {};
                }

            }
            //console.log(JSON.stringify(item));
            addLines({'accountId': this.recordId, 'name_order': this.Name, 'j_items' : JSON.stringify(item)})

                .then(result => {
                    this.dispatchEvent(new CloseActionScreenEvent());
                    eval("$A.get('e.force:refreshView').fire();");
                })
                .catch(error => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error record creation',
                            message: error.body.message,
                            variant: 'error'
                        })
                    );
                });
        } else {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error creating record',
                    message: 'Purchase Order Name cannot be empty.',
                    variant: 'error'
                })
            );
        }

    }
    handleDelete(event) {
        const lineKey = Number(event.detail);
        let index = this.lines.findIndex(line => line.key === lineKey);
        this.lines.splice(index, 1);
    }

}