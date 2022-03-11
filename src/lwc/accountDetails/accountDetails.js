import { LightningElement, api, track } from 'lwc';
import getAccountDetails from '@salesforce/apex/AccountController.getAccountDetails';

//can be also solved by <template if:true={data}> in html
const accmeta = {Owner: {Name: 'loading', FullPhotoUrl: 'loading'}}
 
export default class AccountDetails extends LightningElement {
    @api detailRecordId;
    data = accmeta;
    //Connected Callback makes Apex Call.
    connectedCallback() {
        //start spinner
        getAccountDetails({detailRecordId : this.detailRecordId}).then(data => {
            this.data = data;
            //fire event indicating child data loaded
            this.dispatchEvent(new CustomEvent('detailloaded'));
        }).catch(error => {
            if(error !== undefined) {
                if(typeof error.body.message === 'string') {
                    this.error = error.body.message;
                } else {
                    this.error = 'oops something went wrong!';
                }
            }
        });
    }

    handleBack() {
        this.dispatchEvent(new CustomEvent('backevent'));
    }
}