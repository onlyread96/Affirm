import { LightningElement, wire, track } from 'lwc';
import getAccountList from '@salesforce/apex/AccountController.getAccountList';

const actions = [
    { label: 'Next', name: 'show_detail' }
];

const columns = [
    { label: 'Id', fieldName: 'Id' },
    { label: 'Name', fieldName: 'Name' },
    { label: 'Action', type: 'action', typeAttributes: { rowActions: actions, menuAlignment: 'auto' } }
];

const viewstate = {
    listview: "LIST_VIEW",
    detailview: "DETAIL_VIEW"
};
 
export default class AccountList extends LightningElement {
    @track data = [];
    columns = columns;
    error;
    viewstate = viewstate.listview;
    detailRecordId;
    loaded = false;
    get showListView() {
        return this.viewstate === viewstate.listview;
    }

    get showDetailView() {
        return this.viewstate === viewstate.detailview;
    }
    //Connected Callback makes Apex Call.
    connectedCallback() {
        //start spinner
        getAccountList().then(data => {
            this.loaded = true;
            this.data = data
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
    /* Start: Event Handlers*/
    handleDetailLoaded() {
        //stop spinner
        console.log('child loaded');
        this.loaded = true;
    }

    handleBackEvent() {
        this.viewstate = viewstate.listview;
    }

    handleRowAction(event) {
        const action = event.detail.action;
        const row = event.detail.row;
        switch (action.name) {
            case 'show_detail':
                this.loaded = false;
                this.viewstate = viewstate.detailview;
                this.detailRecordId = row.Id;
                break;
        }
    }
    /* End: Event Handlers*/
}