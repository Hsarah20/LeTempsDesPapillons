trigger OrderTrigger on Order (before update) {

    List<Delivery__c> listDeliveries = new List<Delivery__c>();
    
    for (Order ord : Trigger.new) {
        // Vérifier si la commande est valide
        Boolean isValid = OrderService.validateOrder(ord);
        if (!isValid) {
            ord.addError('La commande ne respecte pas les critères de validation.');
        }
       
        //On crier une Livraison si la commande est validee
        if (isValid && ord.ShippingCountry != null) {
            Account acc = AccountSelector.getAccountById(ord.AccountId);
            Carrier_Price__c  bestCarrierPrice =(TransporterSelector.getBestCarrierByCriteria(ord.ShippingCountry,acc.Customer_Type__c))[0];   

            if ( bestCarrierPrice != null) {
                //on crée une livraison avec ce transporteur
                Delivery__c del = new Delivery__c();
                del.Delivery_Date__c = Date.today().addDays(Integer.valueOf(bestCarrierPrice.Delivery_Time__c));
                del.Status__c = 'En cours';
                del.Carrier_Price__r.id = bestCarrierPrice.Id;
                del.Order__r.Id = ord.Id; 

                listDeliveries.add(del);
            }
        }

        ord.Status= 'Validated';
    }


    // on persiste toutes les livraisons dans la bd
    if(listDeliveries.size()>0)
    {
        insert listDeliveries;
    }
}