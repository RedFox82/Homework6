public class PurchaseOrderService {

    public static void PurchaseOrderUpdate (List<PurchaseOrder__c> oldPO, List<PurchaseOrder__c> newPO) {
        Set<String> Ids_To_Complete = new Set<String>();
        Set<String> Ids_To_Draft = new Set<String>();

        List<PurchaseOrderLineItem__c> poLinesInc = new List<PurchaseOrderLineItem__c>();
        List<PurchaseOrderLineItem__c> poLinesDec = new List<PurchaseOrderLineItem__c>();

        List<Product2> updateProducts = new List<Product2>();

        String oldStatus = '';

        //Collecting Ids PO
        for (PurchaseOrder__c po : newPO) {
            for (PurchaseOrder__c p : oldPO) {
                if (p.Id == po.Id) {
                    oldStatus = p.Status__c;
                    break;
                }
            }
            if (po.Status__c == 'Completed' && oldStatus == 'Draft') {
                Ids_To_Complete.add(po.Id);
            }
            else if (po.Status__c == 'Draft' && oldStatus == 'Completed') {
                Ids_To_Draft.add(po.Id);
            }
        }

        if (!Ids_To_Complete.isEmpty()) {
            poLinesInc = PurchaseOrderSelector.selectPurchaseOrderLines(Ids_To_Complete);
        }
        if (!Ids_To_Draft.isEmpty()) {
            poLinesDec = PurchaseOrderSelector.selectPurchaseOrderLines(Ids_To_Draft);
        }

        if (!poLinesInc.isEmpty() || !poLinesDec.isEmpty()) {
            Set<String> Ids_Product = new Set<String>();

            for (PurchaseOrderLineItem__c line : poLinesInc) {
                Ids_Product.add(line.Product__c);
            }
            for (PurchaseOrderLineItem__c line : poLinesDec) {
                Ids_Product.add(line.Product__c);
            }

            updateProducts = PurchaseOrderSelector.selectProducts(Ids_Product);

            for (Product2 product : updateProducts) {
                for (PurchaseOrderLineItem__c line : poLinesInc) {
                    if (line.Product__c == product.Id) {
                        product.Stock__c += line.Quantity__c;
                    }
                }
                for (PurchaseOrderLineItem__c line : poLinesDec) {
                    if (line.Product__c == product.Id) {
                        if (product.Stock__c >= line.Quantity__c) {
                            product.Stock__c -= line.Quantity__c;
                        }
                    }
                }
            }

        }

        if (!updateProducts.isEmpty()) {
            update updateProducts;
        }
    }

    public static void PurchaseOrderRollback(List<PurchaseOrder__c> oldPO, List<PurchaseOrder__c> newPO) {
        Set<String> Ids_To_Draft= new Set<String>();
        List<PurchaseOrder__c> purchaseOrders = new List<PurchaseOrder__c>();
        Set<PurchaseOrder__c> rollbackOrders = new Set<PurchaseOrder__c>();
        List<PurchaseOrderLineItem__c> purchaseOrderLines = new List<PurchaseOrderLineItem__c>();
        List<Product2> products = new List<Product2>();
        String oldStatus = '';

        //Collecting Ids PO
        for (PurchaseOrder__c po : newPO) {
            for (PurchaseOrder__c p : oldPO) {
                if (p.Id == po.Id) {
                    oldStatus = p.Status__c;
                    break;
                }
            }
            if (po.Status__c == 'Draft' && oldStatus == 'Completed') {
                Ids_To_Draft.add(po.Id);
            }
        }
        if (!Ids_To_Draft.isEmpty()) {
            purchaseOrders = PurchaseOrderSelector.selectPurchaseOrders(Ids_To_Draft);
            Ids_To_Draft.clear();
        }
        if (!purchaseOrders.isEmpty()) {
            for (PurchaseOrder__c po : purchaseOrders) {
                for (PurchaseOrderLineItem__c poLine : po.PurchaseOrderLineItems__r) {
                    Ids_To_Draft.add(poLine.Product__c);
                }
            }
        }
        if (!Ids_To_Draft.isEmpty()) {
            products = PurchaseOrderSelector.selectProducts(Ids_To_Draft);
        }
        if (!products.isEmpty()) {
            for (PurchaseOrder__c po : purchaseOrders) {
                for (PurchaseOrderLineItem__c poLine : po.PurchaseOrderLineItems__r) {
                    for (Product2 p : products) {
                        if (poLine.Quantity__c > p.Stock__c) {
                            rollbackOrders.add(po);
                            break;
                        }
                    }
                }
            }
        }

        if (!rollbackOrders.isEmpty()) {
            for (PurchaseOrder__c po : rollbackOrders) {
                for (PurchaseOrder__c p : newPO) {
                    if (p.Id == po.Id) {
                        p.Status__c = 'Completed';
                        p.addError('You do not have enough products!');
                        break;
                    }
                }
            }
        }

    }

}