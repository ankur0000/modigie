import GetUser from '@salesforce/apex/AuthorizationClass.GetUser';
import { api, LightningElement, track, wire } from 'lwc';


export default class customLookUp extends LightningElement {

    @api objName;
    @api iconName;
    @api objectList;
    @api filter = '';
    @api searchPlaceholder='Search';
    @track selectedName;
    @track records;
    @track isValueSelected;
    @track blurTimeout;
    @api userId;
    @track selectedUsers = [];
    searchTerm;
    //css
    @track boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus';
    @track inputClass = '';
    @wire(GetUser, {searchTerm : 'searchTerm'})
    wiredRecords({ error, data }) {
        if (data) {
            this.error = undefined;
            this.records = data;
            console.log('data' , this.records);
        } else if (error) {
            this.error = error;
            this.records = undefined;
        }
    }
    handleClick() {
        this.searchTerm = '';
        this.inputClass = 'slds-has-focus';
        this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus slds-is-open';
    }

    onBlur() {
        this.blurTimeout = setTimeout(() =>  {this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus'}, 300);
    }

    onSelect(event){
        let selectedId = event.currentTarget.dataset.id;
        let selectedName = event.currentTarget.dataset.name;
        console.log('OnSelect----->',JSON.stringify(this.objectList));
        this.selectedUsers.push({'id': selectedId, 'userName': selectedName});
        console.log('selectedUsers---->',JSON.stringify(this.selectedUsers));
        const valueSelectedEvent = new CustomEvent('lookupselected', {detail:  {'id': selectedId, 'userName': selectedName} });
        this.dispatchEvent(valueSelectedEvent);
        this.isValueSelected = true;
        this.selectedName = selectedName;
        if(this.blurTimeout) {
            clearTimeout(this.blurTimeout);
        }
        this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus';
    }

    handleRemovePill() {
        this.isValueSelected = false;
    }

    onChange(event) {
        this.searchTerm = event.target.value;
        this.searchUser=event.target.value;
        console.log('SSSSSS', this.searchUser)
        GetUser({searchTerm: this.searchUser, dataMap: this.objectList}) 
            .then(result => {
                console.log('see' , result);          
                this.records = result;
            })
    }
    connectedCallback(){
        if(this.userId!= null && this.userId!= undefined){
            this.isValueSelected = true;
        }
    }
}