import { LightningElement, api,wire } from 'lwc';
import getOrderById from '@salesforce/apex/OrderService.getOrderById';
import permission from '@salesforce/apex/PermissionController.UserhasPermissiontoSendOrder';

export default class OrderDeliveryModal extends LightningElement {
    @api recordId;
    @api orderId;
    @api orderNumber;
    @api deliveryCountry;
    @api customerType;
    @api accountId;

    isModalOpen = false;
    hasPermission=false;

    connectedCallback(event) {
        console.log('record id ' + this.recordId);
    }

    //Verifier si l'utilisateur a les permissions d'envoi d'une commande
     @wire(permission)
     wiredPermission({ error, data }) {
        if (data) {            
            this.hasPermission = data;
        }else{
            console.log('erreur '+ error)
        }
     }

    // Récupération  de la commande en cours
    @wire(getOrderById, { orderId: '$recordId' })
    wiredOrder({ error, data }) {
          if (data) {
              this.currentOrder = data;
              this.orderNumber = this.currentOrder.OrderNumber;
              this.deliveryCountry=this.currentOrder.ShippingCountry
              this.accountId=this.currentOrder.AccountId;
                  
          } else if (error) {
              console.error('Erreur lors de la récupération de la commande', error);
          }
    }

    // Ouvre la modal
    openModal() {
        this.isModalOpen = true;
    }

    // Ferme la modal
    closeModal() {
        this.isModalOpen = false;
    }

    // Gère la confirmation du transporteur
    handleDeliveryConfirmed(event) {
        alert(`Livraison confirmée avec ${event.detail.carrierName}`);
        this.closeModal();
    }
}
