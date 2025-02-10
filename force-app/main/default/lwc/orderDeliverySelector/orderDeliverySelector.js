import { LightningElement, api, wire } from 'lwc';
import getBestCarriersByCriteria from '@salesforce/apex/TransporterSelector.getBestCarrierByCriteria';
import getAccountById from '@salesforce/apex/AccountSelector.getAccountById';
import createDelivery from '@salesforce/apex/TransporterSelector.createDelivery';
import { RefreshEvent } from 'lightning/refresh';


export default class OrderDeliverySelector extends LightningElement {
    @api orderId; 
    @api deliveryCountry; 
    @api orderNumber;
    @api accountId;

    customerType = '';
    carriers = [];
    carrierOptions = [];
    selectedCarrier = '';
    selectedCarrierDetails = null;

    connectedCallback(event) {
       // console.log('selector account id '+this.accountId);
    }

    // Récupération  de la commande en cours
    @wire(getAccountById, { accountId: '$accountId' })
    wiredAccout({ error, data }) {
        if (data) {
            //console.log('account data '+JSON.stringify(data))
           // console.log('Customer Type '+ data.Customer_Type__c)
            this.customerType = data.Customer_Type__c;
                
        } else if (error) {
            console.error('Erreur lors de la récupération d\'account', error);
        }
    }
    

    get isConfirmDisabled() {
        return !this.selectedCarrier;
    }
    
    // // Récupération des transporteurs disponibles
    @wire(getBestCarriersByCriteria, { country: '$deliveryCountry', customerType: '$customerType' })
    wiredCarriers({ error, data }) {
        if (data) {
           // console.log('carriers data '+JSON.stringify(data));
            this.carriers = data;
            this.carrierOptions = data.map(carrier => ({
                label: `${carrier.Account__r.Name} - ${carrier.Price__c}€ (${carrier.Delivery_Time__c}j)`,
                value: carrier.Id
            }));
        } else if (error) {
            console.error('Erreur lors de la récupération des transporteurs', error);
        }
    }

    // Mise à jour du transporteur sélectionné
    handleCarrierChange(event) {
        this.selectedCarrier = event.detail.value;
        this.selectedCarrierDetails = this.carriers.find(c => c.Id === this.selectedCarrier);
    }

    // Confirmation de la livraison
    handleConfirmDelivery() {
        if (this.selectedCarrierDetails) {
            const selectedCarrierEvent = new CustomEvent('deliveryconfirmed', {
                detail: {
                    orderId: this.orderId,
                    carrierId: this.selectedCarrier,
                    carrierName: this.selectedCarrierDetails.Account__r.Name
                }
            });
            this.dispatchEvent(selectedCarrierEvent);
            this.CreateDeliveryFromSelectedCarrier(this.orderId, this.selectedCarrierDetails.Id);
            this.dispatchEvent(new RefreshEvent());
           
        } 
    }
    //Créer une Livraison du transporteur sélectionné
    CreateDeliveryFromSelectedCarrier(orderId, carrierId) {
        // console.log('Order id '+ orderId );
        // console.log('Carrier price id '+ carrierId );
       createDelivery({ carrierPriceId: carrierId, orderId: orderId });
       console.log("livraison terminée");
    }

    
}


