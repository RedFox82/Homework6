public with sharing class Homework9 {

//Contacts list for tests
    public static List<Contact> myContacts() {
        List<Contact> myContacts = new List<Contact>();

            myContacts.add(new Contact(FirstName='Rose', LastName='Gonzalez', AccountId='0017R00002pUf9lQAC', Email='rose@edge.com'));
            myContacts.add(new Contact(FirstName='Rose', LastName='Gonzalez', AccountId='0017R00002pUf9lQAC', Email='rose@edge.com'));
            myContacts.add(new Contact(FirstName='Sean', LastName='Forbes', AccountId='0017R00002pUf9lQAC', Email='sean@edge.com'));
            myContacts.add(new Contact(FirstName='Jack', LastName='Rogers', AccountId='0017R00002pUf9mQAC', Email='jrogers@burlington.com'));
            myContacts.add(new Contact(FirstName='Pat', LastName='Stumuller', AccountId='0017R00002pUf9nQAC', Email='pat@pyramid.net'));
            myContacts.add(new Contact(FirstName='Andy', LastName='Young', AccountId='0017R00002pUf9oQAC', Email='a_young@dickenson.com'));
            myContacts.add(new Contact(FirstName='Tim', LastName='Barr', AccountId='0017R00002pUf9pQAC', Email='barr_tim@grandhotels.com'));
            myContacts.add(new Contact(FirstName='John', LastName='Bond', AccountId='0017R00002pUf9pQAC', Email='bond_john@grandhotels.com'));
            myContacts.add(new Contact(FirstName='Stella', LastName='Pavlova', AccountId='0017R00002pUf9qQAC', Email='spavlova@uog.com'));
            myContacts.add(new Contact(FirstName='Lauren', LastName='Boyle', AccountId='0017R00002pUf9qQAC', Email='lboyle@uog.com'));

        return myContacts;
    }


//Opportunity list for tests
    public static List<Opportunity> myOpportunity() {
        List<Opportunity> myOppsList = new List<Opportunity>();

            myOppsList.add(new Opportunity(AccountId='0017R00002pUf9oQAC', Name='Dickenson Mobile Generators', Amount=9000000.00));
            myOppsList.add(new Opportunity(AccountId='0017R00002pUf9qQAC', Name='United Oil Office Portable Generators', Amount=125000.00));
            myOppsList.add(new Opportunity(AccountId='0017R00002pUf9rQAC', Name='Express Logistics Standby Generator', Amount=220000.00));
            myOppsList.add(new Opportunity(AccountId='0017R00002pUf9vQAC', Name='GenePoint Standby Generator', Amount=85000.00));
            myOppsList.add(new Opportunity(AccountId='0017R00002pUf9vQAC', Name='GenePoint Standby Generator', Amount=85000.00));
            myOppsList.add(new Opportunity(AccountId='0017R00002pUf9pQAC', Name='Grand Hotels Kitchen Generator', Amount=15000.00));
            myOppsList.add(new Opportunity(AccountId='0017R00002pUf9qQAC', Name='United Oil Refinery Generators', Amount=270000.00));
            myOppsList.add(new Opportunity(AccountId='0017R00002pUf9qQAC', Name='United Oil SLA', Amount=120000.00));
            myOppsList.add(new Opportunity(AccountId='0017R00002pUf9pQAC', Name='Grand Hotels Guest Portable Generators', Amount=250000.00));
            myOppsList.add(new Opportunity(AccountId='0017R00002pUf9qQAC', Name='opp_test', Amount=15000000.00));

        return myOppsList;
    }


//Task1. Get unique values in list
    public static Set<Object> get_unique_values(List<Object> inp_list) {
        return new Set<Object>(inp_list);
    }


//Task2. Get Contact by Name
    public static Contact get_contact_by_name(String inp_name, List<Contact> contacts) {
        Contact retrn_contact = new Contact();
            for (Contact contact : contacts) {
                if (contact.FirstName == inp_name) {
                    retrn_contact = contact;
                    break;
                }
            }
        return retrn_contact;
    }


//Task3. Get Opportunity with the biggest amount
    public static Opportunity get_opportunity_max(List<Opportunity> opps) {
        Opportunity biggestAmountOpp = new Opportunity();
        List<Decimal> amount_opp = new List<Decimal>();

        for (Opportunity opp : opps) {
            amount_opp.add(opp.Amount);
        }
        amount_opp.sort();
        for (Opportunity opp : opps) {
            if (opp.Amount == amount_opp[amount_opp.size()-1]) {
                biggestAmountOpp = opp;
                break;
            }
        }
        return biggestAmountOpp;
    }


//Task4. A function that takes a number and returns a list of its digits.
    public static List<Integer> list_digits(Integer numbers) {
        List<Integer> digits = new List<Integer>();
        List<Integer> digits_reverse = new List<Integer>();

        Integer sign = 1;
        if (numbers < 0) {sign = -1;}

        if (numbers != 0) {
            while (numbers != 0) {
                digits.add(Math.abs(Math.mod(numbers, 10)));
                numbers = numbers / 10;
            }
            for (Integer i = digits.size(); i > 0; i--) {
                if (i == digits.size()) {
                    digits_reverse.add(sign * digits[i-1]);
                } else {
                    digits_reverse.add(digits[i-1]);
                }
            }
        } else {digits_reverse.add(0);}

        return digits_reverse;
    }





}