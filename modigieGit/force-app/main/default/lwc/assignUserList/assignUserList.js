import { LightningElement, track, api , wire } from 'lwc';
import getCreditId from '@salesforce/apex/AuthorizationClass.getCreditId';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import GetUser from '@salesforce/apex/AuthorizationClass.GetUser';
import saveAssignUserDetails from '@salesforce/apex/AuthorizationClass.saveAssignUserDetails';
import getAssignedUsers from '@salesforce/apex/AuthorizationClass.getAssignedUsers';
import { getRecord } from 'lightning/uiRecordApi';
const FIELDS = [
    'User.Name',
];
export default class AssignUserList extends LightningElement {
    @track objectList = [];
    @track dataObject;
    @track searchObject;
    @track check;
    @track remove;
    @track searchUser='';
    @track username = [];
    @track creditUserId;
    @api objName;
    @api iconName;
    @api filter = '';
    @api searchPlaceholder='Search';
    @track selectedName;
    @track records;
    @track isValueSelected;
    @track blurTimeout;
    @track isDataLoaded= false;
    searchTerm;
    
    //css
    @track boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus';
    @track inputClass = '';
    connectedCallback(){
        console.log('jkjckjdskjfds');
        getCreditId().then(result =>{
            console.log('result' , result);
            // this.username = result;    
            for (var key in result) {
                console.log('key' ,result[key] );
                let temp  = {label: result[key].modigie__Title__c , value:result[key].Id};
                this.username.push(temp);
            }

            getAssignedUsers().then(result => {
                console.log('assignedUsers------>', result);
                console.log('lenght is.......' ,Object.keys(result).length);
                console.log('value.....' , Object.keys(result));
                var arr = Object.keys(result);
               // console.log('store....' , store);
                //console.log('array first ....' , result.get(arr[0]));
                console.log('array second....' , result[arr[1]]);
                // var parse = JSON.parse(result);
                // console.log('parse is.........' , parse);
                var count  = Object.keys(result).length;
                // getRecord({ recordId: arr[0], fields: FIELDS }).then(result =>{
                //     console.log('Name is' , result);
                // }).catch(error => {
                //     console.log(error);
                // });
                for(var i = 0 ; i < result.length; i++){
                    console.log('Id assign.....' , result[i]);   
                    // getRecord({ recordId: result[arr[i]].Id, fields: FIELDS }).then(result =>{
                    //     console.log('Name is' , result);
                    // }).catch(error => {
                    //     console.log(error);
                    // });
                    
                    console.log('User assign.......' , arr[i]);
                    this.objectList.push({
                        "selectedId": result[i].modigie__Credit_RecordId__c,
                        "selectedUser": result[i].modigie__User_Id__c,
                        "selectedUserName": result[i].modigie__User_Name__c,
                        "creditTitle": result[i].modigie__CreditId_Name__c
                    });
                    
                    console.log('objectlist value......' , JSON.stringify(this.objectList));
                }   
                this.isDataLoaded = true;    
                // for(var key in count){
                //     console.log('Id assign.....' , result.arr[i].Id);   
                //     console.log('User assign.......' , result.arr[i].modigie__Title__c);
                // }
            });
        });

        
    }
    addNewRow() {
        // call the comman "createObjectData" helper method for add new Object Row to List  
        var RowItemList = this.objectList;
        RowItemList.push({
            "selectedId": null,
            "selectedUser": null,
            "selectedUserName": null,
            "creditTitle": null
        });
        // set the updated list to attribute (contactList) again    
        this.objectList = RowItemList;
        console.log('------->',this.objectList);
    }
    deleteRow(event) {
        this.check = event.target.dataset.index;
        console.log('check obj' , JSON.stringify(this.objectList));
        console.log('check', this.check);
         this.objectList.splice(this.check, 1);
        console.log('remove', JSON.stringify(this.objectList));
    }
    closemodal(){
        console.log("running");
        const closeassignuser  = new CustomEvent("closeassignuser" , {
            
        })
        this.dispatchEvent(closeassignuser);
    }

   

    //input box method

  
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

    onSelect(event) {
        let selectedId = event.currentTarget.dataset.id;
        let selectedName = event.currentTarget.dataset.name;
        const valueSelectedEvent = new CustomEvent('lookupselected', {detail:  selectedId });
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

    handleChange(event){
        console.log('sdhg' , event.target.dataset.index);
        console.log('doosra' , event.target.value);
        this.objectList[event.target.dataset.index].selectedId = event.target.value;
        // console.log(JSON.stringify(this.username));
        for(let i = 0; i < this.username.length; i++){
            if(this.username[i].value == event.target.value){
                this.objectList[event.target.dataset.index].creditTitle = this.username[i].label;
            }
        }
        console.log(JSON.stringify(this.objectList));
        // this.objectList[event.target.dataset.index].creditTitle = 
    }

    handleUserSelection(event){
        console.log(event.target.dataset.index+"the selected record id is"+event.detail);
        
        this.objectList[event.target.dataset.index].selectedUser = event.detail['id'];
        this.objectList[event.target.dataset.index].selectedUserName = event.detail['userName'];
        console.log('ObjList---->',JSON.stringify(this.objectList));
    }

    handleSaveButton(){
        let anyErrors = false;
        for(let i = 0; i < this.objectList.length; i++){
            console.log(this.objectList[i].selectedId);
            if(this.objectList[i].selectedId == null || this.objectList[i].selectedUser == null){
                anyErrors = true;
            }
        }
        if(anyErrors){
            const event = new ShowToastEvent({
                title: 'Error',
                message: 'Please provide valid details or delete the row!!!!',
                variant: 'Error',
            });
            this.dispatchEvent(event);
        }
        else{
            saveAssignUserDetails({details: this.objectList});
            console.log("running", JSON.stringify(this.objectList));
            const saveassignuser  = new CustomEvent("saveassignuser" , {})
            this.dispatchEvent(saveassignuser);
        }
        
    }
    
}