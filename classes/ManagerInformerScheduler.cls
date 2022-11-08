public class ManagerInformerScheduler implements Schedulable{

    public static Integer crHours = 19;
    public static Integer crMins = 20;
    public static Integer crSecs = 0;
    public static String cronExp = crSecs + ' ' + crMins + ' ' + crHours + ' 1/1 * ? *';

    public void execute(SchedulableContext schedulableContext) {

        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
        FROM CronTrigger
        WHERE Id = :schedulableContext.getTriggerId()];

        System.assertEquals(cronExp, ct.CronExpression);

        Datetime now = Datetime.now();

        String dt_fire = '';
        if ((now.hour() < crHours) ||
                (now.hour() == crHours && (now.minute() < crMins ||
                        (now.minute() == crMins && now.second() < crSecs)))) {
            dt_fire = now.format('yyyy-MM-dd');
        } else {
            dt_fire = (now + 1).format('yyyy-MM-dd');
        }

        String tm_fire = '';
        if (crHours < 10) {
            tm_fire = tm_fire + '0' + String.valueOf(crHours) + ':';
        } else {
            tm_fire = tm_fire + String.valueOf(crHours) + ':';
        }
        if (crMins < 10) {
            tm_fire = tm_fire + '0' + String.valueOf(crMins) + ':';
        } else {
            tm_fire = tm_fire + String.valueOf(crMins) + ':';
        }
        if (crSecs < 10) {
            tm_fire = tm_fire + '0' + String.valueOf(crSecs);
        } else {
            tm_fire = tm_fire + String.valueOf(crSecs);
        }

        System.assertEquals(dt_fire + ' ' + tm_fire, String.valueOf(ct.NextFireTime));

        List<Product2> active_products = ProductSelector.selectProduct2s();
        List<Opportunity> active_opportunity = OpportunitySelector.selectOpportunities();

        Map<Id, Decimal> opp_products = new Map<Id, Decimal>();

        for (Opportunity opportunity : active_opportunity) {
            List<OpportunityLineItem> oppLineItems = opportunity.OpportunityLineItems;
            for (OpportunityLineItem ol : oppLineItems) {
                if (opp_products.get(ol.Product2.Id) == null) {
                    opp_products.put(ol.Product2.Id, ol.Quantity);
                } else {
                    Decimal q = opp_products.get(ol.Product2.Id) + ol.Quantity;
                    opp_products.put(ol.Product2.Id, q);
                }
            }
        }

        Map<Product2, Decimal> Pr_Ids = new Map<Product2, Decimal>();
        Set<PurchaseOrder__c> Pu_Ids = new Set<PurchaseOrder__c>();
        for (Id id : opp_products.keySet()) {
            for (Product2 p : active_products) {
                if (p.Id == id) {
                    if (opp_products.get(id) > p.Stock__c) {
                        Pr_Ids.put(p, opp_products.get(id));
                        Pu_Ids.addAll(selectPurchaseOrders(id));
                        break;
                    }
                }
            }
        }
        if (!Pr_Ids.isEmpty()) {
            String str_prId = ' ';
            String str_puId = ' ';

            for(Product2 pr : Pr_Ids.keySet()) {
                str_prId += '<p> Name: ' + pr.Name + ', Quantity in Stock: ' + pr.Stock__c +' / Required amount: ' + Pr_Ids.get(pr) + '</p>';
            }

            for(PurchaseOrder__c pu : Pu_Ids) {
                str_puId += '<p> Id: ' + pu.Id + ', Name: ' + pu.Name +', Created date: ' + pu.CreatedDate + '</p>';
            }
            String role = 'Manager';
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<String> toAddresses = new List<String>();
            toAddresses.add([SELECT Email  FROM User WHERE UserRole.Name = :role LIMIT 1].Email);
            mail.toAddresses = toAddresses;
            mail.setHtmlBody('<b>Your have not enough products in Stock.:</b>' + str_prId +
            '<b>Not completed purchase:</b>'+ str_puId);

            mail.setSubject('Notification for purchasing products');

            try {
                if (mail.getHtmlBody() != null) {
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                } else {
                    throw new EmailException('Messages must be not null!');
                }
            }
            catch (EmailException e) {
                System.debug(e.getMessage());
            }
        }
    }

    private static List<PurchaseOrder__c> selectPurchaseOrders(String productId) {
        List<PurchaseOrder__c> purchaseOrders = new List<PurchaseOrder__c>();
        List<PurchaseOrder__c> active_purchase = PurchaseOrderSelector.draftPurchaseOrders();

        for (PurchaseOrder__c po : active_purchase) {
            for(PurchaseOrderLineItem__c line : po.PurchaseOrderLineItems__r) {
                if (line.Product__c == productId) {
                    purchaseOrders.add(po);
                    break;
                }
            }
        }

        return purchaseOrders;
    }

}